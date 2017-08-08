module FinanceManager
  class Engine < ::Rails::Engine
    config.autoload_paths += %W(#{config.root}/lib)
    # config.autoload_paths += %W(#{config.root}/app/models/plans #{config.root}/app/models/business)

    # Run Migrations in this Engine instead of host app
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
  end
end
