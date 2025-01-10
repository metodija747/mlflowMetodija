locals {
  # Build up the Basic Auth .htpasswd lines
  htpasswd_commands = join("\n",
    concat(
      [
        "htpasswd -bBc /etc/nginx/.htpasswd \"${var.mlflow_users[0].username}\" \"${var.mlflow_users[0].password}\""
      ],
      [
        for i in range(1, length(var.mlflow_users)) :
        "htpasswd -bb /etc/nginx/.htpasswd \"${var.mlflow_users[i].username}\" \"${var.mlflow_users[i].password}\""
      ]
    )
  )
}