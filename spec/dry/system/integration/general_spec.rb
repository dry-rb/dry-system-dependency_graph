# frozen_string_literal: true

require 'dry/system/container'
require 'dry/system/dependency_graph'
require 'dry/events'
require 'dry/monitor/notifications'

RSpec.describe 'Full app' do
  subject(:system) do
    Class.new(Dry::System::Container) do
      use :dependency_graph
      use :monitoring

      configure do |config|
        config.ignored_dependencies = %i[not_registered]
      end

      boot(:db) do
        init do
          module Test
            class Db
            end
          end
        end

        start do
          register('db.conn', Test::Db.new)
        end
      end

      boot(:client) do
        init do
          module Test
            class Client
            end
          end
        end

        start do
          register('client.conn', Test::Client.new)
        end
      end
    end
  end

  context 'with normal dry-system app' do
    before do
      Dry::System::DependencyGraph.register!(system)
      system.finalize!
    end

    let(:xdot) { system[:dependency_graph].graph.output( xdot: String ) }

    it { expect(system[:dependency_graph]).to be_a(Dry::System::DependencyGraph::Base) }

    it { expect(xdot).to match('db.conn') }
    it { expect(xdot).to match('client.conn') }
  end

  context 'works well with namespaces' do
    before do
      Dry::System::DependencyGraph.register!(system)

      ns = Dry::Container::Namespace.new('persistance') do
        register('users') { Array.new }
      end
      system.import(ns)

      system.finalize!
    end

    let(:xdot) { system[:dependency_graph].graph.output( xdot: String ) }

    it { expect(xdot).to match('persistance.users') }
    it { expect(xdot).to match('db.conn') }
    it { expect(xdot).to match('client.conn') }
  end
end
