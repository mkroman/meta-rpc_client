#!/usr/bin/gem build
# frozen_string_literal: true

require_relative './lib/meta/rpc/version'

Gem::Specification.new do |spec|
  spec.name     = 'meta-rpc_client'
  spec.version  = Meta::RPC::VERSION
  spec.summary  = 'Client implementation for Meta\'s RPC API'

  spec.homepage = 'https://github.com/mkroman/meta-rpc_client'
  spec.license  = 'MIT'
  spec.author   = 'Mikkel Kroman'
  spec.email    = 'mk@maero.dk'
  spec.files    = Dir['lib/**/*.rb']

  spec.add_runtime_dependency 'multi_json', '~> 1.14'
  spec.add_runtime_dependency 'oj', '~> 3.10'
  spec.add_runtime_dependency 'rbnacl', '~> 7.1'

  spec.add_development_dependency 'guard', '~> 2.16'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'solargraph', '~> 0.38'

  spec.executables << 'meta-rpc_client'

  spec.required_ruby_version = '>= 2.6'
end

# vim: set syntax=ruby:
