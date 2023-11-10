import { convertWordFiles } from 'convert-multiple-files-ul'
import nodePath from 'node:path'
import { chdir, cwd } from 'node:process'
import {
	compressedFile,
	directive,
	distDir,
	readmeFile,
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
		const pdfFilePath = await convertWordFiles(wordFile, 'pdf', distDir, '1')
		await createCompressed({ compressedFilePath, filesToSave: [seedFilePath, pdfFilePath, readmeFile], testsDir })
	}

	const excludeFiles = directive === 'COMPRESS' ? [compressedFile] : [seedFile]
	await deleteFiles({ path: distDir, exclude: excludeFiles })
}

main()
