pid_file = "./pidfile"

exit_after_auth = true

auto_auth {
        method "approle" {
                mount_path = "auth/approle"
                config = {
                        role_id_file_path = "./afs_dla_role-id.txt"
                        secret_id_file_path = "./afs_dla_secret-id.txt"
                        remove_secret_id_file_after_reading = "false"
                }
        }

        sink "file" {
                config = {
                        path = ".vault-token"
                }
        }
}
