# Hosts is a knife plugin to create /etc/hosts listings for your nodes.
# Author: Matt Greensmith
#
# Usage: 'knife hosts' and then copy the output to your /etc/hosts
# You can also use a search query to limit the output.
#
# It adds friendly aliases a couple of ways:
#
# 1. It strips trailing domain elements (default 2) from the end of node names and adds an alias, eg
#    10.1.1.1 foo.bar.com foo
#    You can override the number of domain elements stripped with the -d --drop-elements option,
#    and disable it completely with -d 0.
#
# 2. Rackspace prefaces the hostname of physical nodes with an identifying number, eg 000000-foo.bar.com
#    We strip this number and add the leftover host name as an alias, eg:
#    10.1.1.1 000000-foo.bar.com foo.bar.com
#    If you happen to name your nodes with a leading number and then a hyphen, you may want to disable
#    this behavior with -i --ignore-strip-rackspace option.

require 'chef/knife'

# A quick helper
class String
  def numeric?
    Float(self) != nil rescue false
  end
end

module KnifeHosts

  class Hosts < Chef::Knife

    deps do
      require 'chef/search/query'
    end

    banner "knife hosts QUERY (options)"

    option :drop_elements,
      :short => '-d NUM_ELEMENTS',
      :long => '--drop-elements NUM_ELEMENTS',
      :description => "Number of trailing elements (dot-separated) to drop from a node name. (Default: 2)",
      :default => 2,
      :proc => Proc.new { |d| d.to_i }

    option :ignore_strip_rackspace,
      :short => '-i',
      :long => '--ignore-strip-rackspace',
      :description => "Do not strip leading rackspace identifier (Do Not: nnnnnn-foo.bar.com -> foo.bar.com)",
      :boolean => true
 
    def run
      all_nodes = []
      q = Chef::Search::Query.new
      query = @name_args[0] || "*:*"
      q.search(:node, query) do |node|
        all_nodes << node
      end

      all_nodes.each do |node|
        if node.has_key?("ec2")
          ipaddress = node['ec2']['public_ipv4']
        else
          ipaddress = node['ipaddress']
        end

        if ipaddress
          output_line = Array.new
          output_line << ipaddress
          output_line << node.name

          working_name = node.name

          unless config[:ignore_strip_rackspace]
            n = working_name.split(/-/)
            if n[0].numeric?
              working_name = n.drop(1).join("-")
              output_line << working_name
            end
          end

          if config[:drop_elements] != 0           
            n = working_name.split(/\./)
            output_line << n.first(n.length - config[:drop_elements]).join(".")
          end

          puts output_line.join(" ")
        end
      end
    end 
  end
end