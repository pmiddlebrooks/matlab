function env = get_environment


switch matlabroot
    case '/Applications/MATLAB_R2015a.app'
        hostname = char( getHostName( java.net.InetAddress.getLocalHost ) );
        switch hostname
            case 'pmiddleb-Mac-Pro.local'
                env = 'home';
            otherwise
                env = 'work';
        end
    otherwise
        env = 'accre';
end

