module EtFullSystem
  module Test
    class AdminApi
      def url
        'http://localhost:3001/admin'
      end

      def get_token
        response = request(:get, url)
        self.csrf_token = response.body.match(/csrf-token" content="([^"]*)"/)[1]

      end

      def login
        get_token
        request(:post, "#{url}/login",
          headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          },
          cookies: cookies_hash,
          body: {
            admin_user: {
              email: 'admin@example.com',
              password: 'password',
              remember_me: '0'
            },
            authenticity_token: csrf_token
          })
      end

      def get_claimants
        claimants = request(:get, "#{url}/claimants.json", cookies: cookies_hash)
        JSON.parse(claimants.body).map(&:with_indifferent_access)
      end

      private

      def request(method, *args)
        self.last_response = HTTParty.send(method, *args)
        self.cookies_hash = HTTParty::CookieHash.new
        cookies_hash.add_cookies(last_response.headers['set-cookie'])
        last_response
      end

      attr_accessor :cookies_hash, :last_response, :csrf_token
    end
  end
end