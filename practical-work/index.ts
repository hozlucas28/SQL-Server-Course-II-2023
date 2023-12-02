import { convertWordFiles } from 'convert-multiple-files-ul'
import nodePath from 'node:path'
import { chdir, cwd } from 'node:process'
import {
	compressedFile,
	dataDir,
	directive,
	distDir,
	docsDir,
	readmeFile,
	repositoryDirectAccess,
	seedFile,
	sqlFilesToMerge,
	testsDir,
	wordFile,
} from './constants.js'
import { createCompressed, createSeed, deleteFiles } from './utils.js'

const currentDir = nodePath.join(cwd(), 'practical-work')
chdir(currentDir)

async function main() {
	const seedFilePath = nodePath.join(distDir, seedFile)
	await createSeed({ seedFilePath, sqlFilesToMerge })

	if (directive === 'COMPRESS') {
		const compressedFilePath = nodePath.join(distDir, compressedFile)
		await convertWordFiles(nodePath.join(docsDir, wordFile), 'pdf', docsDir, '1')
		await createCompressed({
			compressedFilePath,
			filesToSave: [seedFilePath, readmeFile, repositoryDirectAccess],
			testsDir,
			dataDir,
			docsDir,
		})
	}

	const excludeFiles = directive === 'COMPRESS' ? [compressedFile] : [seedFile]
	await deleteFiles({ path: distDir, exclude: excludeFiles })
	await deleteFiles({ path: docsDir, exclude: [wordFile] })
}

main()
