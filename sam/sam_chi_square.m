function chiSquare = sam_chi_square(pMObs,pMPrd,fObs)
% SAM_CHI_SQUARE <Synopsis of what this function does>
%
% DESCRIPTION
% <Describe more extensively what this function does>
%
% SYNTAX
% SAM_CHI_SQUARE;
%
% pMObs observed probability mass
% pMPrd predicted probability mass
% fObs observed frequency
%
% EXAMPLES
%
% .........................................................................
% Bram Zandbelt, bramzandbelt@gmail.com
% $Created : Wed 18 Sep 2013 17:03:57 CDT by bram
% $Modified: Wed 18 Sep 2013 17:06:56 CDT by bram

chiSquare = sum((((pMObs.*fObs) - (pMPrd.*fObs)).^2) ./ (pMPrd.*fObs));
