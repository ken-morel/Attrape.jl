#!/usr/bin/fish

function build_sysimage
    echo "Building custom sysimage... (This may take several minutes)"
    julia --project=.sysimg -e 'using Pkg; Pkg.instantiate()'

    cd .sysimg
    julia --project=. build_sysimage.jl
    cd ..

    if test -f .sysimg/sysimg.so
        echo "Sysimage built successfully at: $sysimage_path"
    else
        echo "Error: Sysimage build failed."
    end
end

function run_script
    set file_to_run $argv[1]
    set script_args $argv[2..-1]

    if not test -f $sysimage_path
        echo "Sysimage not found. Please run './mng.fish build' first."
        return 1
    end

    if test -z "$file_to_run"
        echo "Usage: ./mng.fish run <filename> [args...]"
        echo "Starting a REPL instead..."
        julia --project -J.sysimg/sysimg.so
        return 0
    end

    echo "Running '$file_to_run' with custom sysimage..."
    # The -J flag loads the sysimage
    # The --project flag activates the environment of the current directory
    julia --project -J.sysimg/sysimg.so $file_to_run $script_args
end

# --- Main Command Dispatcher ---

switch $argv[1]
    case build
        build_sysimage
    case run
        run_script $argv[2..-1]
    case '' -h --help
        echo "Atak Development Environment Manager"
        echo ""
        echo "Usage:"
        echo "  ./mng.fish build         - Build or rebuild the custom sysimage."
        echo "  ./mng.fish run <file>    - Run a Julia script with the custom environment."
        echo "  ./mng.fish run           - Start a Julia REPL with the custom environment."
    case '*'
        echo "Unknown command: $argv[1]"
        echo "Run './mng.fish --help' for usage."
        return 1
end
