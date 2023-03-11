//! Generate a readable name that can be used for throwaway infrastructure.

#![warn(
    rust_2018_idioms,
    unused,
    rust_2021_compatibility,
    nonstandard_style,
    future_incompatible,
    missing_copy_implementations,
    missing_debug_implementations,
    missing_docs
)]
use clap::Parser;

use clap::CommandFactory;
use rand::prelude::*;
use rand_pcg::Pcg64;
use std::io::stdout;

use clap_complete::generate;

mod cli;

use crate::cli::Arguments as CliArgs;

fn main() {
    miette::set_panic_hook();

    let args: CliArgs = CliArgs::parse();

    if let Some(shell) = args.completion_shell {
        let mut cmd = CliArgs::command();
        let name = cmd.get_name().to_string();
        generate(shell, &mut cmd, name, &mut stdout());

        return;
    }

    let seperator = args
        .separator
        .expect("Failed to get default value for separator");

    args.initial_seed.map_or_else(
        || {
            let rng = thread_rng();
            println!(
                "{}",
                anarchist_readable_name_generator_lib::readable_name_custom(&seperator, rng)
            );
        },
        |seed| {
            let rng = Pcg64::seed_from_u64(seed);
            println!(
                "{}",
                anarchist_readable_name_generator_lib::readable_name_custom(&seperator, rng)
            );
        },
    );
}
