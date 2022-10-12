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

use cli::cli;
use rand::prelude::*;
use rand_pcg::Pcg64;
use std::io::stdout;

mod cli;
mod completion;

fn main() {
    miette::set_panic_hook();

    let mut app = cli();
    let args = app.clone().get_matches();

    if let Ok(shell) = args.value_of_t("completion_shell") {
        completion::print_completions(&mut stdout(), &mut app, shell);
        return;
    }

    let seperator = args
        .value_of("separator")
        .expect("Failed to get default value for separator");

    args.value_of_t("initial_seed").map_or_else(
        |_| {
            let rng = thread_rng();
            println!(
                "{}",
                anarchist_readable_name_generator_lib::readable_name_custom(seperator, rng)
            );
        },
        |seed| {
            let rng = Pcg64::seed_from_u64(seed);
            println!(
                "{}",
                anarchist_readable_name_generator_lib::readable_name_custom(seperator, rng)
            );
        },
    );
}
