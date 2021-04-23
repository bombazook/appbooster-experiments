# frozen_string_literal: true

App.boot(:experiments) do |app|
  start do
    app.register('experiments.color') do
      variants = { '#FF0000' => 33, '#00FF00' => 33, '#0000FF' => 33 }
      Algorithms::Weighted.new(variants: variants)
    end

    app.register('experiments.price') do
      variants = { 10 => 75, 20 => 10, 50 => 5, 5 => 10 }
      Algorithms::Weighted.new(variants: variants)
    end

    app.register('experiments', -> { Hash[app.keys.select { |k| k =~ /^experiments\./ }&.map { |k| [k, app[k]] }] })
  end
end
