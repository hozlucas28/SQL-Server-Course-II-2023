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
	'01-init.sql',
	'02-schemas.sql',
	'03-tables.sql',
	'04-constraints.sql',
	'05-indexes.sql',
	'06-pre-inserts.sql',
	'07-roles.sql',
	'stored-procedures/',
	'triggers/',
].map((file) => path.join('src', file))
