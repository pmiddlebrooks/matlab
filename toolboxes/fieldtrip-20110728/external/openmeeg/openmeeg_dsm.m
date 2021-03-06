function [dsm] = openmeeg_dsm(pos, vol)

% OPENMEEG_DSM computes the OpenMEEG DSM matrix
%              i.e. Right hand side in the potential equation
%
% Use as
%   [dsm] = openmeeg_dsm(vol, isolated)

% Copyright (C) 2009, Alexandre Gramfort
% INRIA Odyssee Project Team

% Subversion does not use the Log keyword, use 'svn log <filename>' or 'svn -v log | less' to get detailed information


% store the current path and change folder to the temporary one
tmpfolder = cd;
om_checkombin;
try
    cd(tempdir)

    % write the triangulations to file
    bndfile = {};
    for i=1:length(vol.bnd)
        [junk,tname] = fileparts(tempname);
        bndfile{i} = [tname '.tri'];
        om_save_tri(bndfile{i}, vol.bnd(i).pnt, vol.bnd(i).tri);
    end
    
    % these will hold the shell script and the inverted system matrix
    [junk,tname] = fileparts(tempname);
    if ~ispc
      exefile = [tname '.sh'];
    else
      exefile = [tname '.bat'];
    end

    [junk,tname] = fileparts(tempname);
    condfile = [tname '.cond'];
    [junk,tname] = fileparts(tempname);
    geomfile = [tname '.geom'];
    [junk,tname] = fileparts(tempname);
    dipfile = [tname '.dip'];
    [junk,tname] = fileparts(tempname);
    dsmfile = [tname '.bin'];

    % write conductivity and geometry files
    om_write_geom(geomfile,bndfile);
    om_write_cond(condfile,vol.cond);

    % handle dipole file
    ndip = size(pos,1);
    pos = [kron(pos,ones(3,1)) , kron(ones(ndip,1),eye(3))]; % save pos with each 3D orientation
    om_save_full(pos,dipfile,'ascii');

    % Exe file
    efid = fopen(exefile, 'w');
    omp_num_threads = feature('numCores');

    if ~ispc
      fprintf(efid,'#!/usr/bin/env bash\n');
      fprintf(efid,['export OMP_NUM_THREADS=',num2str(omp_num_threads),'\n']);
      % the following implements Galerkin method and switch can be -DSM or -DSMNA
      % (non adaptive), see OMtrunk/src/assembleSourceMat.cpp, operators.cpp
      fprintf(efid,['om_assemble -DSMNA ./',geomfile,' ./',condfile,' ./',dipfile,' ./',dsmfile,' 2>&1 > /dev/null\n']);
    else
      fprintf(efid,['om_assemble -DSMNA ./',geomfile,' ./',condfile,' ./',dipfile,' ./',dsmfile,'\n']);
    end
    fclose(efid);

    if ~ispc
      dos(sprintf('chmod +x %s', exefile));
    end
catch
    cd(tmpfolder)
    rethrow(lasterror)
end

try
    % execute OpenMEEG and read the resulting file
    disp(['Assembling OpenMEEG DSM matrix']);
    stopwatch = tic;
    if ispc
        dos([exefile]);
    else
        dos(['./' exefile]);
    end
    dsm = om_load_full(dsmfile,'binary');
    toc(stopwatch);
    cleaner(vol,bndfile,condfile,geomfile,exefile,dipfile,dsmfile)
    cd(tmpfolder)
catch
    warning('an error ocurred while running OpenMEEG');
    disp(lasterr);
    cleaner(vol,bndfile,condfile,geomfile,exefile,dipfile,dsmfile)
    cd(tmpfolder)
end

function cleaner(vol,bndfile,condfile,geomfile,exefile,dipfile,dsmfile)
% delete the temporary files
for i=1:length(vol.bnd)
    if exist(bndfile{i},'file'),delete(bndfile{i}),end
end
if exist(condfile,'file'),delete(condfile);end
if exist(geomfile,'file'),delete(geomfile);end
if exist(exefile,'file'),delete(exefile);end
if exist(dipfile,'file'),delete(dipfile);end
if exist(dsmfile,'file'),delete(dsmfile);end

