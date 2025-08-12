# Attrape.jl

## Project Overview

Attrape.jl is a Julia library for building graphical user interfaces (GUIs). It acts as a high-level wrapper around [Mousetrap.jl](https://github.com/clemapfel/mousetrap.jl), which in turn provides bindings for the Mousetrap GTK library. The core of Attrape.jl is its integration with [Efus.jl](https://github.com/ken-morel/Efus.jl), a templating and component system that enables a declarative and reactive approach to UI development in Julia.

The project aims to simplify the creation of desktop applications by providing a more intuitive, component-based API, similar to what is found in modern web development frameworks.

## Key Components and Architecture

The project is structured around a few key concepts:

- **`Attrape.jl` (main module):** This is the entry point of the library. It brings together all the different parts of the system, including the application, window, page management, and the Efus templates.

- **`Efus.jl` Integration:** This is the core of Attrape.jl's declarative UI capabilities. Efus.jl provides a DSL (Domain Specific Language) for defining UI components and their properties. Attrape.jl defines a set of Efus templates that correspond to Mousetrap widgets.

- **Templates (`src/Templates`):** This directory contains the definitions for all the UI components that Attrape.jl provides. Each file (e.g., `button.jl`, `label.jl`) defines an Efus `Component` and its corresponding `Backend`. The `Backend` is responsible for mounting the component, which means creating the actual Mousetrap widget and setting its properties.

- **Reactivity:** Attrape.jl uses `Efus.EReactant` to create reactive data bindings. This allows the UI to automatically update when the underlying data changes, and vice-versa. This is achieved through a system of subscriptions and notifications. For example, the `bind` attribute on many components allows you to link a widget's property (like the value of a `SpinButton`) to an `EReactant`.

- **Application and Window Management (`src/application.jl`, `src/window.jl`):** Attrape.jl provides abstractions for managing the application lifecycle. The `Application` struct holds the state of the application, including the main window and the home page. The `Window` struct manages the main window and the navigation stack.

- **Page Navigation (`src/page.jl`, `src/routes.jl`):** The library supports a page-based navigation model. You can define different `View`s or `Page`s and navigate between them. The `Router` is responsible for managing the page stack.

- **Bridge (`src/bridge.jl`):** This file contains the necessary `convert` methods to bridge the gap between the Efus DSL and the Mousetrap library. For example, it converts symbols like `:h` or `:vertical` into the corresponding `Mousetrap.ORIENTATION_HORIZONTAL` or `Mousetrap.ORIENTATION_VERTICAL` enums.

## How it Works

1.  **UI Definition:** The developer defines the UI using the `efusthrow` or `efuspreeval` string macros from Efus.jl. This code is written in the Efus DSL.

2.  **Parsing and Evaluation:** Efus.jl parses this DSL into a tree of `Component` objects.

3.  **Mounting:** When the application is run, Attrape.jl traverses this component tree and calls `mount!` on each component.

4.  **Widget Creation:** The `mount!` function in each component's backend creates the corresponding Mousetrap widget and sets its properties based on the attributes defined in the Efus template.

5.  **Data Binding:** If a `bind` attribute is used, the component subscribes to the provided `EReactant`. When the reactant's value changes, the component's UI is updated. Conversely, when the user interacts with the widget, the component notifies the reactant of the change.

6.  **Application Lifecycle:** The `application` function sets up the main application loop, and `run!` starts it. Attrape.jl handles the creation of the main window and the initial rendering of the home page.

## Examples

The `examples` directory provides a comprehensive set of examples that demonstrate how to use the various components and features of Attrape.jl. These examples are a great starting point for understanding how to build applications with the library.

## Future Development

Attrape.jl is a young project with a lot of potential. Some possible areas for future development include:

-   More components and features.
-   Improved documentation and tutorials.
-   Performance optimizations.
-   A more streamlined installation process.
-   Support for custom styling and theming.
