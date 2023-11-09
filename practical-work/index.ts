import nodePath from 'node:path'
import { chdir, cwd } from 'node:process'
import { compressedFile, directive, distDir, readmeFile, seedFile, sqlFilesToMerge, testsDir } from './constants.js'
import { createCompressed, createSeed, deleteFiles } from './utils.js'

const currentDir = nodePath.join(cwd(), 'practical-work')
chdir(currentDir)

const seedFilePath = nodePath.join(distDir, seedFile)
createSeed({ seedFilePath, sqlFilesToMerge })

if (directive === 'COMPRESS') {
	const compressedFilePath = nodePath.join(distDir, compressedFile)
	createCompressed({ compressedFilePath, filesToSave: [seedFilePath, readmeFile], testsDir })
}

deleteFiles({
	files: ['index.js', 'constants.js', 'utils.js'],
})
