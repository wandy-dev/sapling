module MembershipsHelper
  def role_tag_class(role)
    case role
    when "owner"
      "is-danger"
    when "admin"
      "is-warning"
    else
      "is-info"
    end
  end
end
