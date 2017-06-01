class AppConstraint
  def matches?(request)
    !request.url.include?('/api') &&
        !request.url.include?('/admins') &&
        !request.url.include?('/omniauth')
  end
end
