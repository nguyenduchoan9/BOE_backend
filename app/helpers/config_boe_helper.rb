module ConfigBoeHelper
    require 'yaml'

    def get_time_close
        config = HashWithIndifferentAccess.new(load_yml)
        rs = config['development']['time_close']
        m_hour, m_min = rs.split(':')
        time_struct.new(m_hour.to_i, m_min.to_i)
    end

    def set_time_close(m_hour, m_min)
        time_params = m_hour.to_s.strip + ':' + m_min.to_s.strip
        config = load_yml
        config['development']['time_close'] = time_params
        File.open(Rails.root.join('config/config_boe.yml'), 'w') {|f| f.write config.to_yaml }
    end

    def get_time_group
        config = HashWithIndifferentAccess.new(load_yml)
        rs =    config['development']['time_group_order']
        m_hour, m_min = rs.split(':')
        time_struct.new(m_hour.to_i, m_min.to_i)
    end

    def set_time_group(m_hour, m_min)
        time_params = m_hour.to_s.strip + ':' + m_min.to_s.strip
        config = load_yml
        config['development']['time_group_order'] = time_params
        File.open(Rails.root.join('config/config_boe.yml'), 'w') {|f| f.write config.to_yaml }
    end

    def get_membership_by_name mem_name
        config = HashWithIndifferentAccess.new(load_yml)
        rs = config['development']['membership'][mem_name]
        rs.to_i
    end

    def find_or_creata_membership_point mem_name, mem_point
        if mem_point.is_a? Integer
            config = load_yml
            config['development']['membership'][mem_name] = mem_point
            File.open(Rails.root.join('config/config_boe.yml'), 'w') {|f| f.write config.to_yaml }
        end
    end

    private
    def file_path
        Rails.root.join('config/config_boe.yml')
    end

    def load_yml
        YAML.load_file(file_path)
    end

    def time_struct
        Struct.new(:hour, :min)
    end


end
