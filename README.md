# Shellm: A Simple Ollama Client

**Shellm** is a lightweight client for interacting with the [Ollama](https://ollama.com/) API, written entirely in a single Bash script. It provides a simple interface to generate responses from language models, interact with custom tools, and integrate AI capabilities into everyday Linux workflows.

## Features

- **Single File Script**: No complex dependencies—just a single Bash file.
- **API Integration**: Interacts with an Ollama API server to generate predictions.
- **Tool Execution**: Support for toolchain execution using custom JSON-defined tools.
- **Piping and Chaining**: Seamless integration into shell commands for input/output manipulation.
- **Verbose Mode**: Detailed debugging for troubleshooting or learning.

## Installation

1. Save the `shellm` Bash script to a directory of your choice, e.g., `/usr/local/bin`.
2. Make the script executable:
   ```bash
   chmod +x /usr/local/bin/shellm
   ```
3. Ensure the Ollama API is running on `localhost:11434` or set the `API_URL` environment variable to your specific endpoint.

## Usage

### Basic Command
```bash
shellm "What is the weather like today?"
```

This will generate a response using the default model.

### Options

| Option       | Description                                                                                         |
|--------------|-----------------------------------------------------------------------------------------------------|
| `-u`         | API URL (default: `http://localhost:11434/api`)                                                     |
| `-m`         | Model name (default: `qwen2.5:3b-instruct-q5_K_M`)                                                  |
| `-n`         | Number of predictions to generate (default: `200`)                                                  |
| `-v`         | Verbose mode for debugging                                                                          |
| `-t`         | Activate tool use, allowing Shellm to use and chain tools as specified in JSON configuration files. |
| `prompt`     | The prompt for the model. If reading from stdin, this will prepend to the input.                    |

### Example Commands

#### Simple Prompt
Generate a response to a simple question:
```bash
shellm "Why is the sky blue?"
```

#### Verbose Mode
Enable verbose mode for debugging:
```bash
shellm -v "Explain the theory of relativity in simple terms."
```

#### Custom Model
Use a different model:
```bash
shellm -m "newmodel-v1:6b" "Summarize the plot of 'The Great Gatsby'."
```

#### Use Tools
Enable tool usage mode:
```bash
shellm -t "Translate the following text to French: 'Hello, how are you?'"
```

## Advanced Usage

### Chaining Multiple Invocations

Shellm supports chaining multiple invocations, allowing the user to pass the output of one command as the input to the next. This is useful for refining AI responses or handling complex tasks:

```bash
response=$(shellm "What is the capital of France?")
shellm "Is $response a popular tourist destination?"
```

### Integration with Linux Tasks

Shellm can be easily integrated into daily Linux workflows using piping. Here are a few examples:

#### Example: File Content Summarization
To summarize the contents of a file:
```bash
cat myfile.txt | shellm "Summarize this text"
```

#### Example: AI-Powered Directory Listing
Generate a human-readable summary of files in a directory:
```bash
ls -l | shellm "Explain what these files are."
```

#### Example: Translating System Logs
To translate system logs to another language:
```bash
journalctl -xe | shellm -t "Translate this to Spanish."
```

### Tool Integration

Shellm supports user-defined tools specified in JSON files. This allows Shellm to perform operations beyond simple language model predictions, such as executing shell commands or interacting with APIs. A `tools.json` file can be created in the following directories (priority order):

1. `$XDG_CONFIG_HOME/my_app/tools.json`
2. `~/.config/my_app/tools.json`
3. `~/tools.json`
4. `$(dirname "$0")/tools.json` (same directory as the script)

#### Tool Definition Example

Here’s a sample `tools.json` configuration:
```json
{
  "say": {
    "function": {
      "name": "say",
      "exec": "echo ${message}"
    }
  },
  "get_current_date": {
    "function": {
      "name": "get_current_date",
      "exec": "date '+%Y-%m-%d'"
    }
  }
}
```

#### Example Tool Usage
When tools are enabled (`-t` flag), Shellm can chain tool calls. Example:

```bash
shellm -t "Get the current date and time and tell me if it's a weekend."
```

### Tool Execution Workflow

Shellm's tool execution works in multiple steps:

1. **Parse Request**: The initial prompt is analyzed, and the AI identifies which tools to use.
2. **Tool Execution**: Shellm executes the tools in sequence, using their output for the next tool if necessary.
3. **Final Output**: The result is formatted and presented using a final `say` tool call.

## Environment Variables

| Variable        | Description                                   | Default                              |
|-----------------|-----------------------------------------------|--------------------------------------|
| `API_URL`       | URL of the Ollama API                          | `http://localhost:11434/api`         |
| `MODEL_SMALL`   | Default model to use                           | `qwen2.5:3b-instruct-q5_K_M`         |
| `VERBOSE`       | Enable verbose output                          | `0`                                  |
| `USE_TOOL`      | Enable tool usage mode                         | `0`                                  |

## Debugging

For verbose output, use the `-v` flag:
```bash
shellm -v "Debug the script behavior."
```

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests for bug fixes or new features.

## License

Shellm is released under the GPL License. See the [LICENSE](LICENSE) file for more details.

Enjoy using Shellm to bring AI capabilities directly into your shell! 😊
