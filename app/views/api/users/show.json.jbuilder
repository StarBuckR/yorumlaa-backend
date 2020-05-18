verification = false
verification = true if @user.verification.eql?("true")
json.user @user, :id, :username

json.verified verification

url = nil
if @user.avatar.attached?
    url = url_for(@user.avatar)
end

json.avatar_url url