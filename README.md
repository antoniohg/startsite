# Startsite Script

This script simplifies the process of open a local project environment for web development by automating common tasks.

## Overview

`startsite.sh` automates the common tasks required when beginning work on a web development project, such as:
- Opening the project in VS Code
- Starting a local development server: `npm run dev`
- Opening the site in the default browser: Chrome

## Usage

```bash
startsite.sh [project-path]
```

### Examples

Open the project in specified directory:
```bash
startsite.sh ~/Developer/my-portfolio-site
```
You can also run the script from within the project directory:
```bash
cd ~/Developer/my-portfolio-site
startsite.sh
```

## Features

- One-command project initialization
- Saves time on repetitive startup procedures
- Automatically find the opened server in your browser at `http://localhost:[port]` and open the URL in the browser
- Easy to customize for personal preferences

## Configuration

Edit the script to customize:
- The code editor or IDE to use
- Default port settings
- Browser preferences
- Project-specific commands

## Requirements

- Bash shell environment
- Proper permissions (`chmod +x startsite.sh`)
- Any project-specific dependencies

## License

GNU GENERAL PUBLIC LICENSE Version 3

This script is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This script is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this script. If not, see [https://www.gnu.org/licenses/](https://www.gnu.org/licenses/).