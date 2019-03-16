module AES
  class << self
    def encrypt(plain_text, key, opts = {})
      ::AES::AES.new(key, opts).encrypt(plain_text)
    end

    def decrypt(cipher_text, key, opts = {})
      ::AES::AES.new(key, opts).decrypt(cipher_text)
    end

    def key(length = 256, format = :plain)
      key = ::AES::AES.new('').random_key(length)
      base_64_format(key, format)
    end

    def iv(format = :plain)
      iv = ::AES::AES.new('').random_iv
      base_64_format(iv, format)
    end

    private

    def base_64_format(item, format)
      return item unless format == :base_64

      Base64.encode64(item).chomp
    end
  end

  class AES
    attr_reader :options, :key, :iv, :cipher

    def initialize(key, opts = {})
      merge_options opts
      @cipher = nil
      @key    = key
      @iv   ||= random_iv
    end

    def encrypt(plain_text)
      _setup(:encrypt)
      @cipher.iv = @iv
      return [@iv, _encrypt(plain_text)] unless @options[:format] == :base_64

      b64_e_with_iv_and_encrypt(plain_text)
    end

    def decrypt(cipher_text)
      _setup(:decrypt)
      ctext = @options[:format] == :base_64 ? b64_d(cipher_text) : cipher_text
      @cipher.iv = ctext[0]
      @cipher.update(ctext[1]) + @cipher.final
    end

    def random_iv
      _setup(:encrypt)
      @cipher.random_iv
    end

    def random_key(length = 256)
      _random_seed.unpack1('H*')[0..((length / 8) - 1)]
    end

    private

    def _random_seed(size = 32)
      if defined? OpenSSL::Random
        OpenSSL::Random.random_bytes(size)
      else
        chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
        (1..size).collect { chars[rand(chars.size)] }.join
      end
    end

    def b64_d(data)
      iv_and_ctext = []
      data.split('$').each do |part|
        iv_and_ctext << Base64.decode64(part)
      end
      iv_and_ctext
    end

    def b64_e(data)
      Base64.encode64(data).chomp
    end

    def _encrypt(plain_text)
      @cipher.update(plain_text) + @cipher.final
    end

    def merge_options(opts)
      @options = {
        format: :base_64,
        cipher: 'AES-256-CBC',
        iv: nil,
        padding: true
      }.merge! opts
      _handle_iv
      _handle_padding
    end

    def _handle_iv
      return if @options[:iv].nil?

      @iv = Base64.decode64(@options[:iv]) if @options[:format] == :base_64
    end

    def _handle_padding
      @options[:padding] = @options[:padding] ? 1 : 0
    end

    def _setup(action)
      @cipher ||= OpenSSL::Cipher::Cipher.new(@options[:cipher])
      @cipher.send(action)
      @cipher.padding = @options[:padding]
      @cipher.key = @key.unpack('a2' * 32).map(&:hex).pack('c' * 32)
    end

    def b64_e_with_iv_and_encrypt(plain_text)
      b64_e(@iv) << '$' << b64_e(_encrypt(plain_text))
    end
  end
end
