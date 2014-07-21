function env = get_environment


switch matlabroot
    case '/Applications/MATLAB_R2014a.app'
        hostname = char( getHostName( java.net.InetAddress.getLocalHost ) );
        switch hostname
            case 'pauls-MacBook-Pro.local'
                env = 'home';
            otherwise
                env = 'work';
        end
    otherwise
        env = 'accre';
end

