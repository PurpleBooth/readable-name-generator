use clap_complete::Shell;

use clap::Parser;

#[derive(Parser, Debug)]
#[clap(author, version, about)]
#[cfg_attr(target_os = "windows", clap(bin_name = "readable-name-generator"))]
pub struct Arguments {
    /// The separator to use
    #[clap(
        short,
        long,
        value_parser,
        env = "READABLE_NAME_GENERATOR_SEPARATOR",
        default_value = "_"
    )]
    pub separator: Option<String>,

    /// Use a known seed to generate the readable name for repeatability
    #[clap(
        short,
        long,
        value_parser,
        env = "READABLE_NAME_GENERATOR_INITIAL_SEED",
        required = false
    )]
    pub initial_seed: Option<u64>,

    /// Generate completion for your shell
    #[clap(
        short,
        long,
        value_parser,
        env,
        conflicts_with = "separator",
        conflicts_with = "initial_seed",
        required = false
    )]
    pub completion_shell: Option<Shell>,
}
