require 'benchmark'
require 'json'
require 'azure'
require 'kitchen'

module Kitchen
  module Driver
    class Azure < Kitchen::Driver::SSHBase
      default_config :azure_management_certificate do
        ENV['AZURE_MANAGEMENT_CERTIFICATE']
      end

      default_config :azure_subscription_id do
        ENV['AZURE_SUBSCRIPTION_ID']
      end

      default_config :azure_management_endpoint do
        ENV['AZURE_MANAGEMENT_ENDPOINT'] ||
          'https://management.core.windows.net'
      end

      required_config :azure_management_certificate
      required_config :azure_subscription_id

      def create(state)
        create_server
        state[:server_id] = config[:vm_name]

        info("Azure VM <#{state[:server_id]}> created.")
        state[:hostname] = hostname(state[:server_id])
        wait_for_sshd(state[:hostname], config[:username])
        print '(ssh ready)\n'
        debug("azure:create '#{state[:hostname]}'")
      end

      def destroy(state)
        return if state[:server_id].nil?
        service.delete_virtual_machine(state[:server_id], config[:cloud_service_name])
      end

      private

      def configure
        return if configured?
        Azure.configure do |config|
          config.management_certificate = config[:azure_management_certificate]
          config.subscription_id        = config[:azure_subscription_id]
          config.management_endpoint    = config[:azure_management_endpoint]
        end
        @configured = true
      end

      def configured?
        !!@configured
      end

      def service
        @service ||= begin
          configure
          Azure::VirtualMachineManagementService.new
        end
      end

      def create_server
        service.create_virtual_machine(params, options, config[:add_role])
        service.start_virtual_machine(config[:server_id], config[:cloud_service_name])
      end

      def params
        {
          vm_name: config[:server_id],
          vm_user: config[:vm_user],
          password: config[:password],
          location: config[:location],
          image: config[:image]
        }
      end

      def options
        {
          availability_set_name: config[:availability_set_name],
          virtual_network_name: config[:virtual_network_name],
          storage_account_name: config[:storage_account_name],
          affinity_group_name: config[:affinity_group_name],
          cloud_service_name: config[:cloud_service_name],
          deployment_name: config[:server_id],
          subnet_name: config[:subnet_name],
          tcp_endpoints: config[:tcp_endpoints],
          ssh_port: config[:ssh_port],
          vm_size: config[:vm_size]
        }
      end

      def hostname(vm_name)
        # todo...?
      end
    end
  end
end
