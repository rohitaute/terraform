# git
'''
resource "aws-iam-group" "grp" {
    name = "Garud war"

  
}

resource "aws-iam-group-membership" "demo" {
    name = "iam-demo"
    users = [
        aws-iam-user.user1.rohit,
        aws-iam-user.user2.bunty,
        aws-iam-user.user3.tejas
    ]
    group = aws-iam-group.grp.cloud
    
  
}
