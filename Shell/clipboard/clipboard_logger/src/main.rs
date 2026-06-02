use std::{env, io};

// const SOCKET_PATH: &str = "/run/user/1000/clipboard.sock";

//# Returns
// - raw data in bytes
// - data type
fn read_clipboard_with_metadata() {
}

fn main() {
    let args: Vec<String>= env::args().skip(1).collect();

    for tag in args {
        match tag.as_str() {
            "--add" => {
                read_clipboard_with_metadata();
            },
            "--next" => {

            },
            "--previous" => {

            },
            "--list" => {

            },
            _ => {
                println!("Invalid arguments");
            },
        }
    }

}
