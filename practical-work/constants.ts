import path from 'node:path'

export const directive = (process.argv[2] ?? 'BUILD').toUpperCase() as 'BUILD' | 'COMPRESS'

export const distDir = 'dist'
export const docsDir = 'docs'
export const testsDir = '__tests__'

export const compressedFile = 'database.zip'
export const readmeFile = 'README.md'
export const seedFile = 'seed.sql'
export const wordFile = 'documentation.docx'

export const sqlFilesToMerge: string[] = [
	'init.sql',
	'schemas.sql',
	'tables.sql',
	'constraints.sql',
	'stored-procedures/',
	'triggers/',
	'roles.sql',
].map((file) => path.join('src', file))
