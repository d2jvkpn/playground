// path: ~/.n8n/n8n.config.js
const os = require('os');
const fs = require('fs');
const path = require('path');

module.exports = {
  hooks: {
    workflowExecuteAfter: [
      async function (executionData) {
        //const baseDir = process.cwd();
        const log_dir = path.join(os.homedir(), 'workspace', 'logs');

        if (!fs.existsSync(dir)) {
          fs.mkdirSync(log_dir, { recursive: true });
        }

        const basename = `workflow_${executionData.workflowData.name || executionData.workflowId}`;

        fs.writeFileSync(
          path.join(log_dir, `${basename}_${Date.now()}.json`),
          JSON.stringify(executionData, null, 2),
        );
      }
    ],
  },
};
