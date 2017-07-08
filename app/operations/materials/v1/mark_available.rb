module Materials
    module V1
        class MarkAvailable < Operation

            def process
                mark_available
                { status: true}
            end

            private
            def id_params
                params[:ids]
            end

            def split_id
                id_params.split('')
            end

            def mark_available
                begin
                    ActiveRecord::Base.transaction do
                        split_id.each do |id|
                            Material.find(id).update!(available: true)
                        end
                    end
                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

        end
    end
end
