/******************************************
 *        Copyright (c) xTekC.            *
 *        Licensed under MPL-2.0.         *
 *        See LICENSE for details.        *
 * https://www.mozilla.org/en-US/MPL/2.0/ *
 ******************************************/

mod xcli;
use xcli::cli;

#[tokio::main]
async fn main() {
    cli::cli_main().await;
}

// use cursive::view::Resizable;
// use cursive::views::{Dialog, DummyView, LinearLayout, TextView};
// use cursive::{theme, Cursive, CursiveExt};

// fn main() {
//     let mut siv = Cursive::default();

//     let mut palette = theme::Palette::default();
//     palette[theme::PaletteColor::Background] = theme::Color::Rgb(0, 0, 0); // Black
//     palette[theme::PaletteColor::View] = theme::Color::Rgb(88, 88, 88); // Grey
//     palette[theme::PaletteColor::TitlePrimary] = theme::Color::Rgb(220, 220, 220); // White

//     siv.set_theme(theme::Theme {
//         shadow: false,
//         borders: theme::BorderStyle::Simple,
//         palette,
//     });

//     let left_column = LinearLayout::vertical()
//         .child(DummyView.fixed_height(1)) // 2 rows of space at the top
//         .child(
//             Dialog::around(TextView::new("Project Name Placeholder"))
//                 .title("Projects")
//                 .fixed_width(30)
//                 .full_height(),
//         );

//     let right_column = LinearLayout::vertical()
//         .child(DummyView.fixed_height(1)) // 2 rows of space at the top
//         .child(Dialog::around(TextView::new("Project Name Placeholder")).title("Name"))
//         .child(Dialog::around(TextView::new("Image Placeholder")).title("Image"))
//         .child(
//             Dialog::around(TextView::new("Project Description Placeholder")).title("Description"),
//         )
//         .child(Dialog::around(TextView::new("Todo List Placeholder")).title("Pre-Print Prep"))
//         .child(Dialog::around(TextView::new("Materials Used Placeholder")).title("Print Material"))
//         .child(
//             Dialog::around(TextView::new("Time Estimate Placeholder"))
//                 .title("Estimated Completion Time"),
//         )
//         .full_height()
//         .fixed_width(85);

//     let layout = LinearLayout::horizontal()
//         .child(left_column.full_width())
//         .child(right_column.full_width());

//     siv.add_fullscreen_layer(layout);
//     siv.run();
// }
