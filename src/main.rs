//! Generate a readable name that can be used for throwaway infrastructure.
//!
//! This tool creates human-readable names that are useful for temporary resources,
//! test environments, or any situation where you need a memorable identifier.
//!
//! # Usage
//!
//! ```bash
//! # Generate a name with default separator (_)
//! readable-name-generator
//!
//! # Generate a name with custom separator
//! readable-name-generator --separator -
//!
//! # Generate a deterministic name using a seed
//! readable-name-generator --initial-seed 42
//!
//! # Generate shell completions
//! readable-name-generator --completion-shell bash
//! ```

#![warn(clippy::nursery)]
#![deny(
    unused,
    nonstandard_style,
    future_incompatible,
    missing_copy_implementations,
    missing_debug_implementations,
    clippy::pedantic,
    clippy::complexity,
    clippy::correctness,
    clippy::perf,
    clippy::style,
    clippy::suspicious,
    missing_docs
)]
#![allow(clippy::multiple_crate_versions, clippy::cargo)]

use clap::Parser;

use clap::CommandFactory;
use miette::Result;
use rand::prelude::*;
use std::io::stdout;

use clap_complete::generate;
use rand::rng;

mod cli;

use crate::cli::Arguments as CliArgs;

/// Generate a name based on args (separated for testability)
///
/// # Errors
///
/// Returns an error if the separator is not available
fn generate_name(args: &CliArgs) -> Result<String> {
    let separator = args
        .separator
        .clone()
        .ok_or_else(|| miette::miette!("Failed to get default value for separator"))?;

    match args {
        CliArgs {
            suffix: true,
            initial_seed: Some(seed),
            ..
        } => Ok(
            anarchist_readable_name_generator_lib::readable_name_custom_suffix(
                &separator,
                SmallRng::seed_from_u64(*seed),
            ),
        ),
        CliArgs {
            suffix: false,
            initial_seed: Some(seed),
            ..
        } => Ok(anarchist_readable_name_generator_lib::readable_name_custom(
            &separator,
            SmallRng::seed_from_u64(*seed),
        )),
        CliArgs {
            suffix: true,
            initial_seed: None,
            ..
        } => Ok(
            anarchist_readable_name_generator_lib::readable_name_custom_suffix(&separator, rng()),
        ),
        CliArgs {
            suffix: false,
            initial_seed: None,
            ..
        } => Ok(anarchist_readable_name_generator_lib::readable_name_custom(
            &separator,
            rng(),
        )),
    }
}

/// Main entry point for the application
///
/// # Errors
///
/// Returns an error if there's an issue generating the name
fn main() -> Result<()> {
    miette::set_panic_hook();

    let args: CliArgs = CliArgs::parse();

    if let Some(shell) = args.completion_shell {
        let mut cmd = CliArgs::command();
        let name = cmd.get_name().to_string();
        generate(shell, &mut cmd, name, &mut stdout());

        return Ok(());
    }

    let name = generate_name(&args)?;
    println!("{name}");

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use clap::Parser;
    use std::io;
    use std::panic;
    use std::process::Command;
    use std::str;

    #[test]
    fn test_completion_shell() {
        // Verify completion shell functionality
        let result = panic::catch_unwind(|| {
            let args = CliArgs::parse_from(["program", "--completion-shell", "bash"]);

            assert!(
                args.completion_shell.is_some(),
                "Completion shell should be set"
            );

            if let Some(shell) = args.completion_shell {
                let mut cmd = CliArgs::command();
                let name = cmd.get_name().to_string();

                let mut output = Vec::new();
                generate(shell, &mut cmd, name, &mut io::Cursor::new(&mut output));

                assert!(
                    !output.is_empty(),
                    "Shell completion output should not be empty"
                );
            }
        });

        assert!(
            result.is_ok(),
            "Main function panicked unexpectedly with completion shell"
        );
    }

    #[test]
    fn default_behavior() {
        // Test default arguments behavior
        let output = Command::new("cargo")
            .args(["run", "--"])
            .output()
            .expect("Failed to execute cargo run command");

        assert!(output.status.success(), "cargo run command failed");

        let output_str = str::from_utf8(&output.stdout).expect("Output was not valid UTF-8");

        assert!(
            !output_str.trim().is_empty(),
            "Application output should not be empty"
        );

        assert!(
            output_str.contains('_'),
            "Output should contain the default separator '_'"
        );
    }

    #[test]
    fn suffix_behavior() {
        // Test default arguments behavior
        let output = Command::new("cargo")
            .args(["run", "--quiet", "--", "--suffix"])
            .output()
            .expect("Failed to execute cargo run command");

        assert!(output.status.success(), "cargo run command failed");

        let output_str = str::from_utf8(&output.stdout).expect("Output was not valid UTF-8");

        assert!(
            !output_str.trim().is_empty(),
            "Application output should not be empty"
        );

        assert!(
            output_str.trim_end().ends_with(char::is_numeric),
            "Output should end with a number"
        );
    }

    #[test]
    fn test_application_custom_separator() {
        // This test runs the application with a custom separator and checks its output

        // Run the application with default arguments (for comparison)
        let output = Command::new("cargo")
            .args(["run", "--"])
            .output()
            .expect("Failed to execute cargo run command");

        // Convert the output to a string
        let output_str = str::from_utf8(&output.stdout).expect("Output was not valid UTF-8");

        // Run the application with a custom separator
        let output_custom = Command::new("cargo")
            .args(["run", "--", "--separator", "-"])
            .output()
            .expect("Failed to execute cargo run command with custom separator");

        // Check that the command executed successfully
        assert!(
            output_custom.status.success(),
            "cargo run command with custom separator failed"
        );

        // Convert the output to a string
        let output_custom_str =
            str::from_utf8(&output_custom.stdout).expect("Output was not valid UTF-8");

        // Verify that the output contains the custom separator
        assert!(
            output_custom_str.contains('-'),
            "Output should contain the custom separator '-'"
        );

        // Verify that the outputs are different (random generation)
        assert_ne!(
            output_str, output_custom_str,
            "Different runs should produce different outputs"
        );
    }

    #[test]
    fn test_application_with_seed() {
        // This test verifies deterministic output with the same seed

        // Run the application twice with the same seed
        let seed_output1 = Command::new("cargo")
            .args(["run", "--", "--initial-seed", "42"])
            .output()
            .expect("Failed to execute cargo run command with seed");

        let seed_output2 = Command::new("cargo")
            .args(["run", "--", "--initial-seed", "42"])
            .output()
            .expect("Failed to execute cargo run command with seed");

        // Check that the commands executed successfully
        assert!(
            seed_output1.status.success(),
            "cargo run command with seed failed"
        );
        assert!(
            seed_output2.status.success(),
            "cargo run command with seed failed"
        );

        // Convert the outputs to strings
        let seed_output_str1 =
            str::from_utf8(&seed_output1.stdout).expect("Output was not valid UTF-8");
        let seed_output_str2 =
            str::from_utf8(&seed_output2.stdout).expect("Output was not valid UTF-8");

        // Verify that the outputs are not empty
        assert!(
            !seed_output_str1.trim().is_empty(),
            "Application output with seed should not be empty"
        );
        assert!(
            !seed_output_str2.trim().is_empty(),
            "Application output with seed should not be empty"
        );

        // Verify that both outputs are identical (deterministic with the same seed)
        assert_eq!(
            seed_output_str1, seed_output_str2,
            "Outputs generated with the same seed should be identical"
        );
    }
}
