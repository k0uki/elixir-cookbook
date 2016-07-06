#
# Cookbook Name:: elixir
# Recipe:: _package
#
# Copyright (C) 2013-2015 Jamie Winsor (<jamie@vialstudios.com>)
#

case node['platform_family']
when 'debian'
  node.normal[:apt][:compile_time_update] = true
  node.normal[:erlang][:esl][:version] = "1:18.0"
when 'rhel'
  node.normal[:erlang][:source][:version] = "18.0"
  node.normal[:erlang][:source][:checksum] = "a0b69da34b4f218eb7d63d9e96fc120aa7257bb6c37a0f40fb388e188b4111aa"
end

elixir_path = File.join(node[:elixir][:_versions_path], node[:elixir][:version])

include_recipe "apt::default"
include_recipe "erlang::source"
include_recipe "libarchive"

asset = github_asset "Precompiled.zip" do
  repo "elixir-lang/elixir"
  release "v#{node[:elixir][:version]}"
end

directory elixir_path do
  recursive true
end

libarchive_file "Precompiled.zip" do
  path asset.asset_path
  extract_to elixir_path
end

link node[:elixir][:install_path] do
  to elixir_path
end
