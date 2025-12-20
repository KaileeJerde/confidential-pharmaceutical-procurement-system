#!/usr/bin/env ts-node

/**
 * generate-docs - Generates GitBook-formatted documentation from contracts and tests
 *
 * Usage: ts-node scripts/generate-docs.ts <example-name> [options]
 *
 * Example: ts-node scripts/generate-docs.ts fhe-counter
 */

import * as fs from 'fs';
import * as path from 'path';

enum Color {
  Reset = '\x1b[0m',
  Green = '\x1b[32m',
  Blue = '\x1b[34m',
  Yellow = '\x1b[33m',
  Red = '\x1b[31m',
  Cyan = '\x1b[36m',
}

function log(message: string, color: Color = Color.Reset): void {
  console.log(`${color}${message}${Color.Reset}`);
}

function success(message: string): void {
  log(`✓ ${message}`, Color.Green);
}

function info(message: string): void {
  log(`→ ${message}`, Color.Blue);
}

function error(message: string): never {
  log(`Error: ${message}`, Color.Red);
  process.exit(1);
}

interface DocsConfig {
  title: string;
  description: string;
  contract: string;
  test: string;
  category: string;
}

const EXAMPLES_CONFIG: Record<string, DocsConfig> = {
  'fhe-counter': {
    title: 'FHE Counter',
    description: 'This example demonstrates how to build a confidential counter using FHEVM.',
    contract: 'contracts/basic/FHECounter.sol',
    test: 'test/basic/FHECounter.test.ts',
    category: 'Basic',
  },
  'privacy-pharmaceutical': {
    title: 'Privacy Pharmaceutical Procurement',
    description: 'Advanced example demonstrating encrypted pharmaceutical procurement with private bid matching.',
    contract: 'contracts/PrivacyPharma.sol',
    test: 'test/PrivacyPharma.test.js',
    category: 'Advanced',
  },
};

function generateDocumentation(exampleName: string): void {
  const rootDir = path.resolve(__dirname, '..');
  const docsDir = path.join(rootDir, 'examples');

  if (!EXAMPLES_CONFIG[exampleName]) {
    error(`Unknown example: ${exampleName}`);
  }

  const config = EXAMPLES_CONFIG[exampleName];
  const contractPath = path.join(rootDir, config.contract);
  const testPath = path.join(rootDir, config.test);

  if (!fs.existsSync(contractPath)) {
    error(`Contract not found: ${config.contract}`);
  }

  // Create docs directory if it doesn't exist
  if (!fs.existsSync(docsDir)) {
    fs.mkdirSync(docsDir, { recursive: true });
  }

  info(`Generating documentation for: ${exampleName}`);

  // Read contract and test files
  const contractContent = fs.existsSync(contractPath) ? fs.readFileSync(contractPath, 'utf-8') : '';
  const testContent = fs.existsSync(testPath) ? fs.readFileSync(testPath, 'utf-8') : '';

  // Generate markdown documentation
  const docContent = `# ${config.title}

## Overview

${config.description}

## Contract Code

\`\`\`solidity
${contractContent}
\`\`\`

## Test Code

\`\`\`${testPath.endsWith('.ts') ? 'typescript' : 'javascript'}
${testContent}
\`\`\`

## Key Concepts

This example demonstrates:

- **Encrypted Data Types**: Using \`euint32\`, \`euint64\`, and other encrypted types
- **FHE Operations**: Performing computations on encrypted data
- **Access Control**: Managing permissions with \`FHE.allow\` and \`FHE.allowThis\`
- **Input Proofs**: Validating encrypted inputs with zero-knowledge proofs

## Running the Example

1. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

2. Compile contracts:
   \`\`\`bash
   npm run compile
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm run test
   \`\`\`

## Documentation

- [FHEVM Documentation](https://docs.zama.ai/fhevm)
- [FHEVM Examples](https://docs.zama.org/protocol/examples)

---

**Category**: ${config.category}
`;

  const outputPath = path.join(docsDir, `${exampleName}.md`);
  fs.writeFileSync(outputPath, docContent);

  success(`Documentation generated: ${outputPath}`);

  // Update SUMMARY.md
  updateSummary(docsDir, exampleName, config);
}

function updateSummary(docsDir: string, exampleName: string, config: DocsConfig): void {
  const summaryPath = path.join(docsDir, 'SUMMARY.md');

  let summaryContent = '';
  if (fs.existsSync(summaryPath)) {
    summaryContent = fs.readFileSync(summaryPath, 'utf-8');
  } else {
    summaryContent = `# Summary

## Introduction

* [Overview](README.md)

## Basic Examples

## Advanced Examples

`;
  }

  const link = `* [${config.title}](${exampleName}.md)`;

  // Add to appropriate section
  if (config.category === 'Basic') {
    if (!summaryContent.includes(link)) {
      summaryContent = summaryContent.replace('## Basic Examples\n', `## Basic Examples\n\n${link}\n`);
    }
  } else {
    if (!summaryContent.includes(link)) {
      summaryContent = summaryContent.replace('## Advanced Examples\n', `## Advanced Examples\n\n${link}\n`);
    }
  }

  fs.writeFileSync(summaryPath, summaryContent);
  success('SUMMARY.md updated');
}

function main(): void {
  const args = process.argv.slice(2);

  if (args.length === 0 || args[0] === '--help') {
    log('FHEVM Documentation Generator', Color.Cyan);
    log('\nUsage: ts-node scripts/generate-docs.ts <example-name>\n');
    log('Available examples:', Color.Yellow);
    Object.keys(EXAMPLES_CONFIG).forEach(name => {
      log(`  - ${name}`, Color.Green);
    });
    log('\nOptions:', Color.Yellow);
    log('  --all    Generate documentation for all examples\n');
    process.exit(0);
  }

  if (args[0] === '--all') {
    Object.keys(EXAMPLES_CONFIG).forEach(exampleName => {
      generateDocumentation(exampleName);
    });
  } else {
    generateDocumentation(args[0]);
  }
}

main();
