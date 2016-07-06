#
# Cookbook Name:: elixir
# Recipe:: default
#
# Copyright (C) 2013-2015 Jamie Winsor (<jamie@vialstudios.com>)
#

validate_attributes "elixir"

# Removes source installation before package/source methods were finalized in
# version 0.8.0 of the Elixir cookbook. The install path should always be a
# symlink. If it is not, then delete it and make sure it is.
directory node[:elixir][:install_path] do
  recursive true
  action :delete
  not_if "test -L #{node[:elixir][:install_path]}"
end

directory node[:elixir][:_versions_path] do
  recursive true
end

include_recipe "elixir::_#{node[:elixir][:install_method]}"

bin_path    = File.join(node[:elixir][:install_path], "bin")
executables = ["elixir", "elixirc", "iex", "mix"]

execute "#{bin_path} permission" do
  command "chmod 755 #{bin_path}"
  action :run
end

ebin_path    = File.join(node[:elixir][:install_path], "lib")
execute "#{ebin_path} permission" do
  command "chmod 755 #{ebin_path}/*/ebin"
  action :run
end

executables.each do |executable|
  link "/usr/bin/#{executable}" do
    to File.join(bin_path, executable)
  end
end
