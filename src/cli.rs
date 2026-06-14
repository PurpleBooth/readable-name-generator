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
        env = "READABLE_NAME_GENERATOR_SEPARATOR",
        default_value = "_"
    )]
    pub separator: String,

    /// Suffix a random number to prevent collisions
    #[clap(short = 'n', long, env = "READABLE_NAME_GENERATOR_SUFFIX")]
    pub suffix: bool,

    /// Use a known seed to generate the readable name for repeatability
    #[clap(short, long, env = "READABLE_NAME_GENERATOR_INITIAL_SEED")]
    pub initial_seed: Option<u64>,

    /// Generate completion for your shell
    #[clap(
        short,
        long,
        env,
        conflicts_with = "suffix",
        conflicts_with = "separator",
        conflicts_with = "initial_seed"
    )]
    pub completion_shell: Option<Shell>,
}
