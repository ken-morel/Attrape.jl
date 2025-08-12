# Attrape.jl

[![][img-stable]][doc-stable] [![][img-dev]][doc-dev]

[img-stable]: https://img.shields.io/badge/docs-stable-blue.svg
[doc-stable]: https://github.com/ken-morel/Attrape.jl

[img-dev]: https://img.shields.io/badge/docs-dev-blue.svg
[doc-dev]: https://github.com/ken-morel/Attrape.jl

Attrape.jl is a declarative UI toolkit for Julia, built on top of [Mousetrap.jl](https://github.com/clemapfel/mousetrap.jl) (a Julia wrapper for the GTK-based Mousetrap UI library). It leverages the power of [Efus.jl](https://github.com/ken-morel/Efus.jl) to provide a component-based, declarative syntax for building modern, reactive desktop applications.

## Features

- **Declarative UI:** Define your application's UI using a simple and intuitive syntax, inspired by modern web frameworks.
- **Reactive Data Binding:** Create dynamic applications with two-way data binding. Changes in your application's state are automatically reflected in the UI, and vice-versa.
- **Component-Based Architecture:** Build your UI from a rich set of reusable components, including buttons, sliders, text inputs, and more.
- **Application and Window Management:** Attrape.jl provides a high-level API for managing your application's lifecycle, windows, and navigation.
- **Extensible:** Easily create your own custom components to suit your application's needs.

## Installation

Attrape.jl is still under active development. To install it, you first need to install its dependencies from their GitHub repositories:

```julia
using Pkg
Pkg.add(url="https://github.com/ken-morel/Efus.jl")
Pkg.add(url="https://github.com/ken-morel/Atak.jl")
Pkg.add(url="https://github.com/ken-morel/Attrape.jl")
```

## Getting Started

Here's a simple example of a "Hello, World!" application built with Attrape.jl:

```julia
using Attrape
using Efus
import Mousetrap # It's good practice to import Mousetrap as well

const HelloWorldView = View(
    efusthrow"""
    using Attrape

    Frame label="A beautiful frame" box=v
      Label text="Hello world"
      Label text="Hello world"
    """
) do nmsp, ctx, args
end

function (@main)(::Vector{String})
    return run!(
        application(
            home = HelloWorldView
        )
    )
end
```

In this example:

1.  We define a `View` called `HelloWorldView`.
2.  Inside the `View`, we use the `efusthrow` string macro to define the UI layout using Efus syntax.
3.  We create a `Frame` with a vertical `Box` layout (`box=v`).
4.  Inside the `Frame`, we add two `Label` widgets.
5.  Finally, we create an `application` with `HelloWorldView` as its home page and `run!` it.

## Available Components

Attrape.jl provides a wide range of components to build your application's UI. Here are some of the most common ones:

- `Frame`: A container with an optional label.
- `Box`: A container that arranges its children horizontally or vertically.
- `Label`: A widget that displays a small amount of text.
- `Button`: A clickable button.
- `ToggleButton`: A button that can be toggled between two states.
- `CheckButton`: A checkable button.
- `Switch`: A switch that can be toggled between on and off.
- `SpinButton`: A button with an entry to display a numeric value.
- `Scale`: A slider for selecting a value from a range.
- `ProgressBar`: A widget to indicate progress of an operation.
- `Spinner`: A widget to indicate that an operation is ongoing.
- `Entry`: A single-line text entry widget.
- `TextView`: A multi-line text entry widget.
- `DropDown`: A dropdown menu for selecting from a list of options.
- `ImageDisplay`: A widget to display an image.

For more detailed examples, please see the `examples` directory.

## Contributing

Attrape.jl is an open-source project, and contributions are welcome! If you'd like to contribute, please feel free to open an issue or submit a pull request.

## License

Attrape.jl is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.