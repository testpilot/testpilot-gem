require "thor"

module TestPilot
  class Command < Thor

    include TestPilot::Helpers

    desc :setup, "Setup my account so testpilot can authenticate"
    def setup
      display_header "Authentication"
      TestPilot::Auth.login
      output_with_arrow "Successful."
    end

  end
end
