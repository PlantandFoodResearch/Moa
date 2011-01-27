bowtie_pe
------------------------------------------------



::
    Run BOWTIE on an set of input files (query) vs a database index.


Commands
~~~~~~~~

**clean**
  Remove all job data, not the Moa job itself, note that this must be implemented by the template


**run**
  *no help defined*





Filesets
~~~~~~~~




**fq_forward_input**::
    fastq input files directory - forward

  | *type*: `map`
  | *source*: `{}`
  | *category*: `input`
  | *optional*: `False`
  | *extension*: `{}`
  | *glob*: `{}`
  | *dir*: `{}`







**fq_reverse_input**::
    fastq input files directory - reverse

  | *type*: `map`
  | *source*: `fq_forward_input`
  | *category*: `input`
  | *optional*: `True`
  | *extension*: `{}`
  | *glob*: `{}`
  | *dir*: `{}`







**output**::
    Bam output file

  | *type*: `map`
  | *source*: `fq_forward_input`
  | *category*: `output`
  | *optional*: `{}`
  | *extension*: `{}`
  | *glob*: `{}`
  | *dir*: `{}`






Parameters
~~~~~~~~~~



**default_command**::
    command to run for this template

  | *type*: `{}`
  | *default*: `run`
  | *optional*: `True`



**ebwt_base**::
    The (basename of the) bowtie database to use.

  | *type*: `string`
  | *default*: `{}`
  | *optional*: `False`



**extra_params**::
    extra parameters to feed to bowtie

  | *type*: `string`
  | *default*: ``
  | *optional*: `True`



**input_format**::
    Format of the input files

  | *type*: `set`
  | *default*: `fastq`
  | *optional*: `True`



**max_insertsize**::
    Maximum allowed insertsize

  | *type*: `integer`
  | *default*: `500`
  | *optional*: `True`



**min_insertsize**::
    Minimum allowed insertsize

  | *type*: `integer`
  | *default*: `1`
  | *optional*: `True`



**output_format**::
    Format of the output file

  | *type*: `set`
  | *default*: `bam`
  | *optional*: `True`



**title**::
    A name for this job

  | *type*: `string`
  | *default*: ``
  | *optional*: `False`



Other
~~~~~

**Backend**
  ruff
**Author**
  Yogini Idnani, Mark Fiers
**Creation date**
  Wed Nov 10 07:56:48 2010
**Modification date**
  Wed Nov 10 07:56:48 2010


