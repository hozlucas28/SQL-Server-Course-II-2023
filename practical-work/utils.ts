import JSZip from 'jszip'
import type { Dirent } from 'node:fs'
import { appendFileSync, createWriteStream, existsSync, readFileSync, readdirSync, unlinkSync } from 'node:fs'
import nodePath, { basename } from 'node:path'
import { directive, distDir } from './constants.js'

export function readFile({ path }: { path: string }): string {
	return readFileSync(path, { encoding: 'utf-8' })
}

export function readDir({ path }: { path: string }): Dirent[] {
	return readdirSync(path, { encoding: 'utf-8', withFileTypes: true, recursive: false })
}

export function deleteFiles({ files }: { files: string[] }) {
	for (const file of files) {
		unlinkSync(nodePath.join(distDir, file))
	}
}

export function createSeed({ seedFilePath, sqlFilesToMerge }: { seedFilePath: string; sqlFilesToMerge: string[] }) {
	if (existsSync(seedFilePath)) unlinkSync(seedFilePath)

	for (const sqlFile of sqlFilesToMerge) {
		if (sqlFile.endsWith('/') || sqlFile.endsWith('\\')) {
			const innerFiles = readDir({ path: sqlFile })
			for (const innerFile of innerFiles) {
				const { name, path } = innerFile
				const content = readFile({ path: `${path}${name}` })
				appendFileSync(seedFilePath, `${content}\nGO\n`)
			}
		} else {
			const content = readFile({ path: sqlFile })
			appendFileSync(seedFilePath, `${content}\nGO\n`)
		}
	}

	if (directive === 'BUILD') console.log('Seed file created!')
}

export function createCompressed({
	compressedFilePath,
	filesToSave,
	testsDir,
}: {
	compressedFilePath: string
	filesToSave: string[]
	testsDir?: string
}) {
	const zip = new JSZip()

	if (existsSync(compressedFilePath)) unlinkSync(compressedFilePath)

	for (const file of filesToSave) {
		zip.file(basename(file), readFile({ path: file }))
	}

	if (testsDir) {
		for (const testFile of readDir({ path: testsDir })) {
			const { name, path } = testFile
			const filePath = nodePath.join(path, name)
			zip.file(filePath, readFile({ path: filePath }))
		}
	}

	zip
		.generateNodeStream({ type: 'nodebuffer', streamFiles: true })
		.pipe(createWriteStream(compressedFilePath))
		.on('finish', () => console.log('Compressed created!'))
}
