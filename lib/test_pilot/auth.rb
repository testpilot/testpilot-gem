class TestPilot::Auth
  class << self
    include TestPilot::Helpers

    attr_accessor :credentials

    def login
      delete_credentials
      get_credentials
    end

    def reauthorize
      @credentials = ask_for_and_save_credentials
    end

    def user    # :nodoc:
      get_credentials
      @credentials[0]
    end

    def password    # :nodoc:
      get_credentials
      @credentials[1]
    end

     def get_credentials
      return if @credentials
      unless @credentials = read_credentials
        ask_for_and_save_credentials
      end
      @credentials
    end

    def read_credentials
      File.exists?(credentials_file) and File.read(credentials_file).split("\n")
    end

    def ask_for_credentials
      puts "Enter your TestPilot credentials."

      print "Email: "
      user = ask

      print "Password: "
      password = running_on_windows? ? ask_for_password_on_windows : ask_for_password
      # api_key = Heroku::Client.auth(user, password, host)['api_key']

      [user, password]
    end

    def ask_for_password_on_windows
      require "Win32API"
      char = nil
      password = ''

      while char = Win32API.new("crtdll", "_getch", [ ], "L").Call do
        break if char == 10 || char == 13 # received carriage return or newline
        if char == 127 || char == 8 # backspace and delete
          password.slice!(-1, 1)
        else
          # windows might throw a -1 at us so make sure to handle RangeError
          (password << char.chr) rescue RangeError
        end
      end
      puts
      return password
    end

    def ask_for_password
      echo_off
      trap("INT") do
        echo_on
        exit
      end
      password = ask
      puts
      echo_on
      return password
    end

    def ask_for_and_save_credentials
      begin
        @credentials = ask_for_credentials
        write_credentials
        # check
      # rescue ::RestClient::Unauthorized, ::RestClient::ResourceNotFound => e
      #   delete_credentials
      #   clear
      #   display "Authentication failed."
      #   retry if retry_login?
      #   exit 1
      rescue Exception => e
        delete_credentials
        raise e
      end
    end

    def credentials_file
      "#{home_directory}/.testpilot/credentials"
    end

    def with_tty(&block)
      return unless $stdin.tty?
      begin
        yield
      rescue
        # fails on windows
      end
    end

    def clear
      @credentials = nil
      @client = nil
    end

    def echo_off
      with_tty do
        system "stty -echo"
      end
    end

    def echo_on
      with_tty do
        system "stty echo"
      end
    end

    def write_credentials
      FileUtils.mkdir_p(File.dirname(credentials_file))
      f = File.open(credentials_file, 'w')
      f.puts self.credentials
      f.close
      set_credentials_permissions
    end

    def set_credentials_permissions
      FileUtils.chmod 0700, File.dirname(credentials_file)
      FileUtils.chmod 0600, credentials_file
    end

    def delete_credentials
      FileUtils.rm_f(credentials_file)
      clear
    end
  end
end
