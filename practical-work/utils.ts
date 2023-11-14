import JSZip from 'jszip'
import { createWriteStream, existsSync, statSync } from 'node:fs'
import { appendFile, readFile, readdir, unlink } from 'node:fs/promises'
import nodePath, { basename } from 'node:path'
import { directive } from './constants.js'

export async function deleteFiles({ path, exclude }: { path: string; exclude?: string[] }) {
	const files = await readdir(path, { encoding: 'utf-8', withFileTypes: true, recursive: false })

	for (const file of files) {
		if (exclude?.includes(file.name)) continue
		await unlink(nodePath.join(path, file.name))
	}
}

export async function createSeed({ seedFilePath, sqlFilesToMerge }: { seedFilePath: string; sqlFilesToMerge: string[] }) {
	if (existsSync(seedFilePath)) await unlink(seedFilePath)

	for (const sqlFile of sqlFilesToMerge) {
		if (statSync(sqlFile).isDirectory()) {
			const innerFiles = await readdir(sqlFile, { encoding: 'utf-8', withFileTypes: true, recursive: false })
			for (const innerFile of innerFiles) {
				const { name } = innerFile
				const content = await readFile(nodePath.join(sqlFile, name))
				await appendFile(seedFilePath, `${content}\nGO\n`)
			}
		} else {
			const content = await readFile(sqlFile)
			await appendFile(seedFilePath, `${content}\nGO\n`)
		}
	}

	if (directive === 'BUILD') console.log('Seed file created!')
}

export async function createCompressed({
	compressedFilePath,
	filesToSave,
	testsDir,
	docsDir,
}: {
	compressedFilePath: string
	filesToSave: string[]
	testsDir?: string
	docsDir?: string
}) {
	const zip = new JSZip()

	if (existsSync(compressedFilePath)) await unlink(compressedFilePath)

	for (const file of filesToSave) {
		zip.file(basename(file), await readFile(file))
	}

	if (testsDir) {
		for (const testFile of await readdir(testsDir, { encoding: 'utf-8', withFileTypes: true, recursive: false })) {
			const { name } = testFile
			const filePath = nodePath.join(testsDir, name)
			zip.file(filePath, await readFile(filePath))
		}
	}

	if (docsDir) {
		for (const docFile of await readdir(docsDir, { encoding: 'utf-8', withFileTypes: true, recursive: false })) {
			if (nodePath.extname(docFile.name) === '.docx') continue

			const { name } = docFile
			const filePath = nodePath.join(docsDir, name)
			zip.file(filePath, await readFile(filePath))
		}
	}

	zip
		.generateNodeStream({ type: 'nodebuffer', streamFiles: true })
		.pipe(createWriteStream(compressedFilePath))
		.on('finish', () => console.log('Compressed created!'))
}
