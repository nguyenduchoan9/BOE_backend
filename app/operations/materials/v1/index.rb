module Materials
    module V1
        class Index < Operation

            def process
                rs = []
                Material.all.each do |i|
                    rs << Materials::Serializer.new(i)
                end
                rs
            end

            private
            
        end
    end
end
