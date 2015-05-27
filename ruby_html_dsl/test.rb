require_relative 'html'

File.open("hw.html","w") do |f|
  HTML.create(f) do
    html do
      head do
        title do
          text "Hello, world!"
        end
      end

      body do
        p do
          text "hello world"
          br
          hr
          br
          img src:"1.png", alt:"test"
        end
      end
    end
  end
end

