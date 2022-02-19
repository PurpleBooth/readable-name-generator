use crate::completion::Shell;
use clap::{crate_authors, crate_version, Arg, Command};
use std::str::FromStr;

pub fn cli() -> Command<'static> {
    Command::new(env!("CARGO_PKG_NAME"))
        .bin_name(String::from(env!("CARGO_PKG_NAME")))
        .version(crate_version!())
        .author(crate_authors!())
        .about(env!("CARGO_PKG_DESCRIPTION"))
        .arg(
            Arg::new("separator")
                .help("The separator to use")
                .env("READABLE_NAME_GENERATOR_SEPARATOR")
                .short('s')
                .long("separator")
                .takes_value(true)
                .default_value("_"),
        )
        .arg(
            Arg::new("initial_seed")
                .short('i')
                .long("initial-seed")
                .env("READABLE_NAME_GENERATOR_INITIAL_SEED")
                .required(false)
                .help("Use a known seed to generate the readable name for repeatability")
                .takes_value(true)
                .validator(u64::from_str),
        )
        .arg(
            Arg::new("completion_shell")
                .long("completion")
                .short('c')
                .required(false)
                .takes_value(true)
                .help("Generate completion for your shell")
                .conflicts_with("separator")
                .conflicts_with("initial_seed")
                .validator(Shell::from_str)
                .possible_values(["bash", "elvish", "fish", "powershell", "zsh"]),
        )
}
