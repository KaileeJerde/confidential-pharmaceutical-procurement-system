/**
 * @title Documentation Generator
 * @notice Automatically generates documentation from code annotations
 * @dev Scans test files and contracts for special annotations and generates markdown
 *
 * ## Usage:
 * node scripts/generate-docs.js
 *
 * ## Output:
 * - docs/CONCEPTS.md - Generated FHEVM concepts documentation
 * - docs/API.md - Contract API documentation
 *
 * @chapter automation
 */

const fs = require("fs");
const path = require("path");

/**
 * Main documentation generator class
 */
class DocGenerator {
  constructor() {
    this.chapters = {};
    this.functions = [];
    this.concepts = [];
  }

  /**
   * Parse a file for documentation annotations
   * @param {string} filePath - Path to file to parse
   */
  parseFile(filePath) {
    const content = fs.readFileSync(filePath, "utf8");
    const lines = content.split("\n");

    let currentChapter = null;
    let currentSection = null;
    let currentComment = [];

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];

      // Look for chapter annotations
      if (line.includes("@chapter")) {
        const match = line.match(/@chapter\s+([a-z-]+)/);
        if (match) {
          currentChapter = match[1];
          if (!this.chapters[currentChapter]) {
            this.chapters[currentChapter] = {
              name: currentChapter,
              sections: [],
              examples: [],
            };
          }
        }
      }

      // Look for section annotations
      if (line.includes("@section")) {
        const match = line.match(/@section\s+(.+)/);
        if (match) {
          currentSection = match[1];
        }
      }

      // Collect comments
      if (line.trim().startsWith("*") || line.trim().startsWith("//")) {
        currentComment.push(line.trim());
      }

      // Look for function definitions
      if (line.includes("describe(") || line.includes("it(")) {
        const descMatch = line.match(/describe\("([^"]+)"/);
        const itMatch = line.match(/it\("([^"]+)"/);

        if (descMatch || itMatch) {
          const name = descMatch ? descMatch[1] : itMatch[1];

          this.functions.push({
            name: name,
            chapter: currentChapter,
            section: currentSection,
            comments: [...currentComment],
            file: path.basename(filePath),
          });

          currentComment = [];
        }
      }
    }
  }

  /**
   * Generate markdown documentation
   * @returns {string} Generated markdown content
   */
  generateMarkdown() {
    let md = "# PrivacyPharma - FHEVM Example Documentation\n\n";
    md += "*Auto-generated from code annotations*\n\n";
    md += "## Table of Contents\n\n";

    // Table of contents
    Object.keys(this.chapters).forEach((chapterKey) => {
      const chapter = this.chapters[chapterKey];
      md += `- [${this.formatChapterName(chapter.name)}](#${chapter.name})\n`;
    });

    md += "\n---\n\n";

    // Chapter content
    Object.keys(this.chapters).forEach((chapterKey) => {
      const chapter = this.chapters[chapterKey];
      md += `## ${this.formatChapterName(chapter.name)}\n\n`;

      // Find functions in this chapter
      const chapterFunctions = this.functions.filter(
        (f) => f.chapter === chapter.name
      );

      // Group by section
      const sections = {};
      chapterFunctions.forEach((func) => {
        const section = func.section || "General";
        if (!sections[section]) {
          sections[section] = [];
        }
        sections[section].push(func);
      });

      // Output sections
      Object.keys(sections).forEach((sectionName) => {
        md += `### ${sectionName}\n\n`;

        sections[sectionName].forEach((func) => {
          md += `#### ${func.name}\n\n`;

          if (func.comments.length > 0) {
            md += func.comments.map((c) => c.replace(/^\s*[\*\/]+\s*/, "")).join("\n");
            md += "\n\n";
          }

          md += `*Source: ${func.file}*\n\n`;
        });
      });

      md += "\n---\n\n";
    });

    return md;
  }

  /**
   * Format chapter name for display
   * @param {string} name - Chapter identifier
   * @returns {string} Formatted name
   */
  formatChapterName(name) {
    return name
      .split("-")
      .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
      .join(" ");
  }

  /**
   * Generate API documentation from contract
   * @param {string} contractPath - Path to Solidity contract
   * @returns {string} API documentation markdown
   */
  generateAPIDoc(contractPath) {
    const content = fs.readFileSync(contractPath, "utf8");
    let md = "# PrivacyPharma Contract API\n\n";
    md += "*Auto-generated from contract source*\n\n";

    // Extract functions
    const functionRegex = /function\s+(\w+)\s*\([^)]*\)\s*(external|public)/g;
    const functions = [];
    let match;

    while ((match = functionRegex.exec(content)) !== null) {
      functions.push({
        name: match[1],
        visibility: match[2],
      });
    }

    // Group by type
    const modifiers = functions.filter(
      (f) => f.visibility === "external" && f.name.includes("verify")
    );
    const views = functions.filter((f) => f.name.startsWith("get") || f.name.startsWith("is"));
    const transactions = functions.filter(
      (f) => !views.includes(f) && !modifiers.includes(f)
    );

    md += "## Transaction Functions\n\n";
    transactions.forEach((func) => {
      md += `### ${func.name}()\n\n`;
      md += `- **Visibility:** ${func.visibility}\n`;
      md += `- **Type:** Transaction (modifies state)\n\n`;
    });

    md += "## View Functions\n\n";
    views.forEach((func) => {
      md += `### ${func.name}()\n\n`;
      md += `- **Visibility:** ${func.visibility}\n`;
      md += `- **Type:** View (read-only)\n\n`;
    });

    return md;
  }

  /**
   * Run the documentation generator
   */
  async run() {
    console.log("=".repeat(60));
    console.log("PrivacyPharma Documentation Generator");
    console.log("=".repeat(60));

    // Create docs directory
    const docsDir = path.join(__dirname, "..", "docs");
    if (!fs.existsSync(docsDir)) {
      fs.mkdirSync(docsDir);
      console.log("✅ Created docs directory");
    }

    // Parse test file
    const testFile = path.join(__dirname, "..", "test", "PrivacyPharma.test.js");
    if (fs.existsSync(testFile)) {
      console.log("📖 Parsing test file...");
      this.parseFile(testFile);
      console.log(`   Found ${this.functions.length} test functions`);
      console.log(`   Found ${Object.keys(this.chapters).length} chapters`);
    }

    // Generate concept documentation
    console.log("\n📝 Generating concept documentation...");
    const conceptsDoc = this.generateMarkdown();
    const conceptsPath = path.join(docsDir, "TEST_DOCUMENTATION.md");
    fs.writeFileSync(conceptsPath, conceptsDoc);
    console.log(`   ✅ Saved to ${conceptsPath}`);

    // Generate API documentation
    const contractFile = path.join(__dirname, "..", "contracts", "PrivacyPharma.sol");
    if (fs.existsSync(contractFile)) {
      console.log("\n📝 Generating API documentation...");
      const apiDoc = this.generateAPIDoc(contractFile);
      const apiPath = path.join(docsDir, "API.md");
      fs.writeFileSync(apiPath, apiDoc);
      console.log(`   ✅ Saved to ${apiPath}`);
    }

    // Generate summary
    console.log("\n" + "=".repeat(60));
    console.log("Documentation Summary");
    console.log("=".repeat(60));
    console.log("Chapters documented:");
    Object.keys(this.chapters).forEach((ch) => {
      console.log(`  - ${this.formatChapterName(ch)}`);
    });
    console.log("\nFiles generated:");
    console.log(`  - ${path.relative(process.cwd(), conceptsPath)}`);
    if (fs.existsSync(contractFile)) {
      console.log(`  - ${path.relative(process.cwd(), path.join(docsDir, "API.md"))}`);
    }
    console.log("=".repeat(60));
  }
}

// Run if called directly
if (require.main === module) {
  const generator = new DocGenerator();
  generator.run().catch((error) => {
    console.error("Error generating documentation:", error);
    process.exit(1);
  });
}

module.exports = DocGenerator;
