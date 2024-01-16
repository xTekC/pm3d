/******************************************
 *        Copyright (c) xTekC.            *
 *        Licensed under MPL-2.0.         *
 *        See LICENSE for details.        *
 * https://www.mozilla.org/en-US/MPL/2.0/ *
 ******************************************/

#![allow(unused)]
use clap::Parser;
use pm3d::xcore::core::*;

/// 3D Printing Project Management
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub struct Args {
    /// List all project
    #[arg(short, long)]
    list: bool,
}

pub async fn cli_main() {
    let cli = Args::parse();
}
