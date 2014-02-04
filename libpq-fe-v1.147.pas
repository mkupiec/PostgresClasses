
unit libpq-fe-original;
interface

{
  Automatically converted by H2Pas 1.0.0 from libpq-fe-original.h
  The following command line parameters were used:
    -c
    -p
    libpq-fe-original.h
}

{ Pointers to basic pascal types, inserted by h2pas conversion program.}
Type
  PLongint  = ^Longint;
  PSmallInt = ^SmallInt;
  PByte     = ^Byte;
  PWord     = ^Word;
  PDWord    = ^DWord;
  PDouble   = ^Double;

Type
P_PQconninfoOption  = ^_PQconninfoOption;
P_PQprintOpt  = ^_PQprintOpt;
Pbyte  = ^byte;
Pchar  = ^char;
PConnStatusType  = ^ConnStatusType;
PExecStatusType  = ^ExecStatusType;
PFILE  = ^FILE;
Plongint  = ^longint;
POid  = ^Oid;
PPGcancel  = ^PGcancel;
PPGconn  = ^PGconn;
PpgNotify  = ^pgNotify;
PpgresAttDesc  = ^pgresAttDesc;
PPGresult  = ^PGresult;
PPGTransactionStatusType  = ^PGTransactionStatusType;
PPGVerbosity  = ^PGVerbosity;
PPostgresPollingStatusType  = ^PostgresPollingStatusType;
PPQArgBlock  = ^PQArgBlock;
Ppqbool  = ^pqbool;
PPQconninfoOption  = ^PQconninfoOption;
PPQprintOpt  = ^PQprintOpt;
Psize_t  = ^size_t;
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


{-------------------------------------------------------------------------
 *
 * libpq-fe.h
 *	  This file contains definitions for structures and
 *	  externs for functions used by frontend postgres applications.
 *
 * Portions Copyright (c) 1996-2009, PostgreSQL Global Development Group
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 * $PostgreSQL: pgsql/src/interfaces/libpq/libpq-fe.h,v 1.147 2009/06/11 14:49:14 momjian Exp $
 *
 *-------------------------------------------------------------------------
  }
{$ifndef LIBPQ_FE_H}
{$define LIBPQ_FE_H}
{$include }
{
 * postgres_ext.h defines the backend's externally visible types,
 * such as Oid.
  }
{$include "postgres_ext.h"}
{
 * Option flags for PQcopyResult
  }

const
  PG_COPYRES_ATTRS = $01;  
{ Implies PG_COPYRES_ATTRS  }
  PG_COPYRES_TUPLES = $02;  
  PG_COPYRES_EVENTS = $04;  
  PG_COPYRES_NOTICEHOOKS = $08;  
{ Application-visible enum types  }
{
	 * Although it is okay to add to this list, values which become unused
	 * should never be removed, nor should constants be redefined - that would
	 * break compatibility with existing code.
	  }
{ Non-blocking mode only below here  }
{
	 * The existence of these should never be relied upon - they should only
	 * be used for user feedback or similar purposes.
	  }
{ Waiting for connection to be made.   }
{ Connection OK; waiting to send.	    }
{ Waiting for a response from the
										 * postmaster.		   }
{ Received authentication; waiting for
								 * backend startup.  }
{ Negotiating environment.  }
{ Negotiating SSL.  }
{ Internal state: connect() needed  }
type
  PConnStatusType = ^ConnStatusType;
  ConnStatusType = (CONNECTION_OK,CONNECTION_BAD,CONNECTION_STARTED,
    CONNECTION_MADE,CONNECTION_AWAITING_RESPONSE,
    CONNECTION_AUTH_OK,CONNECTION_SETENV,CONNECTION_SSL_STARTUP,
    CONNECTION_NEEDED);
{ These two indicate that one may	   }
{ use select before polling again.    }
{ unused; keep for awhile for backwards
								 * compatibility  }

  PPostgresPollingStatusType = ^PostgresPollingStatusType;
  PostgresPollingStatusType = (PGRES_POLLING_FAILED := 0,PGRES_POLLING_READING,
    PGRES_POLLING_WRITING,PGRES_POLLING_OK,
    PGRES_POLLING_ACTIVE);
{ empty query string was executed  }
{ a query command that doesn't return
								 * anything was executed properly by the
								 * backend  }
{ a query command that returns tuples was
								 * executed properly by the backend, PGresult
								 * contains the result tuples  }
{ Copy Out data transfer in progress  }
{ Copy In data transfer in progress  }
{ an unexpected response was recv'd from the
								 * backend  }
{ notice or warning message  }
{ query failed  }

  PExecStatusType = ^ExecStatusType;
  ExecStatusType = (PGRES_EMPTY_QUERY := 0,PGRES_COMMAND_OK,
    PGRES_TUPLES_OK,PGRES_COPY_OUT,PGRES_COPY_IN,
    PGRES_BAD_RESPONSE,PGRES_NONFATAL_ERROR,
    PGRES_FATAL_ERROR);
{ connection idle  }
{ command in progress  }
{ idle, within transaction block  }
{ idle, within failed transaction  }
{ cannot determine status  }

  PPGTransactionStatusType = ^PGTransactionStatusType;
  PGTransactionStatusType = (PQTRANS_IDLE,PQTRANS_ACTIVE,PQTRANS_INTRANS,
    PQTRANS_INERROR,PQTRANS_UNKNOWN);
{ single-line error messages  }
{ recommended style  }
{ all the facts, ma'am  }

  PPGVerbosity = ^PGVerbosity;
  PGVerbosity = (PQERRORS_TERSE,PQERRORS_DEFAULT,PQERRORS_VERBOSE
    );
{ PGconn encapsulates a connection to the backend.
 * The contents of this struct are not supposed to be known to applications.
  }
  pg_conn = PGconn;
{ PGresult encapsulates the result of a query (or more precisely, of a single
 * SQL command --- a query string given to PQsendQuery can contain multiple
 * commands and thus return multiple PGresult objects).
 * The contents of this struct are not supposed to be known to applications.
  }
  pg_result = PGresult;
{ PGcancel encapsulates the information needed to cancel a running
 * query on an existing connection.
 * The contents of this struct are not supposed to be known to applications.
  }
  pg_cancel = PGcancel;
{ PGnotify represents the occurrence of a NOTIFY message.
 * Ideally this would be an opaque typedef, but it's so simple that it's
 * unlikely to change.
 * NOTE: in Postgres 6.4 and later, the be_pid is the notifying backend's,
 * whereas in earlier versions it was always your own backend's PID.
  }
{ notification condition name  }
{ process ID of notifying server process  }
{ notification parameter  }
{ Fields below here are private to libpq; apps should not use 'em  }
{ list link  }

  PpgNotify = ^pgNotify;
  pgNotify = record
      relname : Pchar;
      be_pid : longint;
      extra : Pchar;
      next : PpgNotify;
    end;
{ Function types for notice-handling callbacks  }
(* Const before type ignored *)

  PQnoticeReceiver = procedure (arg:pointer; res:PPGresult);cdecl;
(* Const before type ignored *)

  PQnoticeProcessor = procedure (arg:pointer; message:Pchar);cdecl;
{ Print options for PQprint()  }

  Ppqbool = ^pqbool;
  pqbool = char;
{ print output field headings and row count  }
{ fill align the fields  }
{ old brain dead format  }
{ output html tables  }
{ expand tables  }
{ use pager for output if needed  }
{ field separator  }
{ insert to HTML   }
{ HTML 
  }
{ null terminated array of replacement field
								 * names  }

  P_PQprintOpt = ^_PQprintOpt;
  _PQprintOpt = record
      header : pqbool;
      align : pqbool;
      standard : pqbool;
      html3 : pqbool;
      expanded : pqbool;
      pager : pqbool;
      fieldSep : Pchar;
      tableOpt : Pchar;
      caption : Pchar;
      fieldName : ^Pchar;
    end;
  PQprintOpt = _PQprintOpt;
  PPQprintOpt = ^PQprintOpt;
{ ----------------
 * Structure for the conninfo parameter definitions returned by PQconndefaults
 * or PQconninfoParse.
 *
 * All fields except "val" point at static strings which must not be altered.
 * "val" is either NULL or a malloc'd current-value string.  PQconninfoFree()
 * will release both the val strings and the PQconninfoOption array itself.
 * ----------------
  }
{ The keyword of the option			 }
{ Fallback environment variable name	 }
{ Fallback compiled in default value	 }
{ Option's current value, or NULL		  }
{ Label for field in connect dialog	 }
{ Indicates how to display this field in a
								 * connect dialog. Values are: "" Display
								 * entered value as is "*" Password field -
								 * hide value "D"  Debug option - don't show
								 * by default  }
{ Field size in characters for dialog	 }

  P_PQconninfoOption = ^_PQconninfoOption;
  _PQconninfoOption = record
      keyword : Pchar;
      envvar : Pchar;
      compiled : Pchar;
      val : Pchar;
      _label : Pchar;
      dispchar : Pchar;
      dispsize : longint;
    end;
  PQconninfoOption = _PQconninfoOption;
  PPQconninfoOption = ^PQconninfoOption;
{ ----------------
 * PQArgBlock -- structure for PQfn() arguments
 * ----------------
  }
{ can't use void (dec compiler barfs)	  }

  PPQArgBlock = ^PQArgBlock;
  PQArgBlock = record
      len : longint;
      isint : longint;
      u : record
          case longint of
            0 : ( ptr : Plongint );
            1 : ( integer : longint );
          end;
    end;
{ ----------------
 * PGresAttDesc -- Data about a single attribute (column) of a query result
 * ----------------
  }
{ column name  }
{ source table, if known  }
{ source column, if known  }
{ format code for value (text/binary)  }
{ type id  }
{ type size  }
{ type-specific modifier info  }

  PpgresAttDesc = ^pgresAttDesc;
  pgresAttDesc = record
      name : Pchar;
      tableid : Oid;
      columnid : longint;
      format : longint;
      typid : Oid;
      typlen : longint;
      atttypmod : longint;
    end;
{ ----------------
 * Exported functions of libpq
 * ----------------
  }
{ ===	in fe-connect.c ===  }
{ make a new client connection to the backend  }
{ Asynchronous (non-blocking)  }
(* Const before type ignored *)

function PQconnectStart(conninfo:Pchar):PPGconn;cdecl;
function PQconnectPoll(conn:PPGconn):PostgresPollingStatusType;cdecl;
{ Synchronous (blocking)  }
(* Const before type ignored *)
function PQconnectdb(conninfo:Pchar):PPGconn;cdecl;
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
function PQsetdbLogin(pghost:Pchar; pgport:Pchar; pgoptions:Pchar; pgtty:Pchar; dbName:Pchar; 
           login:Pchar; pwd:Pchar):PPGconn;cdecl;
{ was #define dname(params) para_def_expr }
{ argument types are unknown }
{ return type might be wrong }   
function PQsetdb(M_PGHOST,M_PGPORT,M_PGOPT,M_PGTTY,M_DBNAME : longint) : longint;

{ close the current connection and free the PGconn data structure  }
procedure PQfinish(conn:PPGconn);cdecl;
{ get info about connection options known to PQconnectdb  }
function PQconndefaults:PPQconninfoOption;cdecl;
{ parse connection options in same way as PQconnectdb  }
(* Const before type ignored *)
function PQconninfoParse(conninfo:Pchar; errmsg:PPchar):PPQconninfoOption;cdecl;
{ free the data structure returned by PQconndefaults() or PQconninfoParse()  }
procedure PQconninfoFree(connOptions:PPQconninfoOption);cdecl;
{
 * close the current connection and restablish a new one with the same
 * parameters
  }
{ Asynchronous (non-blocking)  }
function PQresetStart(conn:PPGconn):longint;cdecl;
function PQresetPoll(conn:PPGconn):PostgresPollingStatusType;cdecl;
{ Synchronous (blocking)  }
procedure PQreset(conn:PPGconn);cdecl;
{ request a cancel structure  }
function PQgetCancel(conn:PPGconn):PPGcancel;cdecl;
{ free a cancel structure  }
procedure PQfreeCancel(cancel:PPGcancel);cdecl;
{ issue a cancel request  }
function PQcancel(cancel:PPGcancel; errbuf:Pchar; errbufsize:longint):longint;cdecl;
{ backwards compatible version of PQcancel; not thread-safe  }
function PQrequestCancel(conn:PPGconn):longint;cdecl;
{ Accessor functions for PGconn objects  }
(* Const before type ignored *)
function PQdb(conn:PPGconn):Pchar;cdecl;
(* Const before type ignored *)
function PQuser(conn:PPGconn):Pchar;cdecl;
(* Const before type ignored *)
function PQpass(conn:PPGconn):Pchar;cdecl;
(* Const before type ignored *)
function PQhost(conn:PPGconn):Pchar;cdecl;
(* Const before type ignored *)
function PQport(conn:PPGconn):Pchar;cdecl;
(* Const before type ignored *)
function PQtty(conn:PPGconn):Pchar;cdecl;
(* Const before type ignored *)
function PQoptions(conn:PPGconn):Pchar;cdecl;
(* Const before type ignored *)
function PQstatus(conn:PPGconn):ConnStatusType;cdecl;
(* Const before type ignored *)
function PQtransactionStatus(conn:PPGconn):PGTransactionStatusType;cdecl;
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
function PQparameterStatus(conn:PPGconn; paramName:Pchar):Pchar;cdecl;
(* Const before type ignored *)
function PQprotocolVersion(conn:PPGconn):longint;cdecl;
(* Const before type ignored *)
function PQserverVersion(conn:PPGconn):longint;cdecl;
(* Const before type ignored *)
function PQerrorMessage(conn:PPGconn):Pchar;cdecl;
(* Const before type ignored *)
function PQsocket(conn:PPGconn):longint;cdecl;
(* Const before type ignored *)
function PQbackendPID(conn:PPGconn):longint;cdecl;
(* Const before type ignored *)
function PQconnectionNeedsPassword(conn:PPGconn):longint;cdecl;
(* Const before type ignored *)
function PQconnectionUsedPassword(conn:PPGconn):longint;cdecl;
(* Const before type ignored *)
function PQclientEncoding(conn:PPGconn):longint;cdecl;
(* Const before type ignored *)
function PQsetClientEncoding(conn:PPGconn; encoding:Pchar):longint;cdecl;
{ Get the OpenSSL structure associated with a connection. Returns NULL for
 * unencrypted connections or if any other TLS library is in use.  }
function PQgetssl(conn:PPGconn):pointer;cdecl;
{ Tell libpq whether it needs to initialize OpenSSL  }
procedure PQinitSSL(do_init:longint);cdecl;
{ More detailed way to tell libpq whether it needs to initialize OpenSSL  }
procedure PQinitOpenSSL(do_ssl:longint; do_crypto:longint);cdecl;
{ Set verbosity for PQerrorMessage and PQresultErrorMessage  }
function PQsetErrorVerbosity(conn:PPGconn; verbosity:PGVerbosity):PGVerbosity;cdecl;
{ Enable/disable tracing  }
procedure PQtrace(conn:PPGconn; debug_port:PFILE);cdecl;
procedure PQuntrace(conn:PPGconn);cdecl;
{ Override default notice handling routines  }
function PQsetNoticeReceiver(conn:PPGconn; proc:PQnoticeReceiver; arg:pointer):PQnoticeReceiver;cdecl;
function PQsetNoticeProcessor(conn:PPGconn; proc:PQnoticeProcessor; arg:pointer):PQnoticeProcessor;cdecl;
{
 *	   Used to set callback that prevents concurrent access to
 *	   non-thread safe functions that libpq needs.
 *	   The default implementation uses a libpq internal mutex.
 *	   Only required for multithreaded apps that use kerberos
 *	   both within their app and for postgresql connections.
  }
type

  pgthreadlock_t = procedure (acquire:longint);cdecl;

function PQregisterThreadLock(newhandler:pgthreadlock_t):pgthreadlock_t;cdecl;
{ === in fe-exec.c ===  }
{ Simple synchronous query  }
(* Const before type ignored *)
function PQexec(conn:PPGconn; query:Pchar):PPGresult;cdecl;
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before declarator ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
function PQexecParams(conn:PPGconn; command:Pchar; nParams:longint; paramTypes:POid; paramValues:PPchar; 
           paramLengths:Plongint; paramFormats:Plongint; resultFormat:longint):PPGresult;cdecl;
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
function PQprepare(conn:PPGconn; stmtName:Pchar; query:Pchar; nParams:longint; paramTypes:POid):PPGresult;cdecl;
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before declarator ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
function PQexecPrepared(conn:PPGconn; stmtName:Pchar; nParams:longint; paramValues:PPchar; paramLengths:Plongint; 
           paramFormats:Plongint; resultFormat:longint):PPGresult;cdecl;
{ Interface for multiple-result or asynchronous queries  }
(* Const before type ignored *)
function PQsendQuery(conn:PPGconn; query:Pchar):longint;cdecl;
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before declarator ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
function PQsendQueryParams(conn:PPGconn; command:Pchar; nParams:longint; paramTypes:POid; paramValues:PPchar; 
           paramLengths:Plongint; paramFormats:Plongint; resultFormat:longint):longint;cdecl;
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
function PQsendPrepare(conn:PPGconn; stmtName:Pchar; query:Pchar; nParams:longint; paramTypes:POid):longint;cdecl;
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before declarator ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
function PQsendQueryPrepared(conn:PPGconn; stmtName:Pchar; nParams:longint; paramValues:PPchar; paramLengths:Plongint; 
           paramFormats:Plongint; resultFormat:longint):longint;cdecl;
function PQgetResult(conn:PPGconn):PPGresult;cdecl;
{ Routines for managing an asynchronous query  }
function PQisBusy(conn:PPGconn):longint;cdecl;
function PQconsumeInput(conn:PPGconn):longint;cdecl;
{ LISTEN/NOTIFY support  }
function PQnotifies(conn:PPGconn):PPGnotify;cdecl;
{ Routines for copy in/out  }
(* Const before type ignored *)
function PQputCopyData(conn:PPGconn; buffer:Pchar; nbytes:longint):longint;cdecl;
(* Const before type ignored *)
function PQputCopyEnd(conn:PPGconn; errormsg:Pchar):longint;cdecl;
function PQgetCopyData(conn:PPGconn; buffer:PPchar; async:longint):longint;cdecl;
{ Deprecated routines for copy in/out  }
function PQgetline(conn:PPGconn; _string:Pchar; length:longint):longint;cdecl;
(* Const before type ignored *)
function PQputline(conn:PPGconn; _string:Pchar):longint;cdecl;
function PQgetlineAsync(conn:PPGconn; buffer:Pchar; bufsize:longint):longint;cdecl;
(* Const before type ignored *)
function PQputnbytes(conn:PPGconn; buffer:Pchar; nbytes:longint):longint;cdecl;
function PQendcopy(conn:PPGconn):longint;cdecl;
{ Set blocking/nonblocking connection to the backend  }
function PQsetnonblocking(conn:PPGconn; arg:longint):longint;cdecl;
(* Const before type ignored *)
function PQisnonblocking(conn:PPGconn):longint;cdecl;
function PQisthreadsafe:longint;cdecl;
{ Force the write buffer to be written (or at least try)  }
function PQflush(conn:PPGconn):longint;cdecl;
{
 * "Fast path" interface --- not really recommended for application
 * use
  }
(* Const before type ignored *)
function PQfn(conn:PPGconn; fnid:longint; result_buf:Plongint; result_len:Plongint; result_is_int:longint; 
           args:PPQArgBlock; nargs:longint):PPGresult;cdecl;
{ Accessor functions for PGresult objects  }
(* Const before type ignored *)
function PQresultStatus(res:PPGresult):ExecStatusType;cdecl;
function PQresStatus(status:ExecStatusType):Pchar;cdecl;
(* Const before type ignored *)
function PQresultErrorMessage(res:PPGresult):Pchar;cdecl;
(* Const before type ignored *)
function PQresultErrorField(res:PPGresult; fieldcode:longint):Pchar;cdecl;
(* Const before type ignored *)
function PQntuples(res:PPGresult):longint;cdecl;
(* Const before type ignored *)
function PQnfields(res:PPGresult):longint;cdecl;
(* Const before type ignored *)
function PQbinaryTuples(res:PPGresult):longint;cdecl;
(* Const before type ignored *)
function PQfname(res:PPGresult; field_num:longint):Pchar;cdecl;
(* Const before type ignored *)
(* Const before type ignored *)
function PQfnumber(res:PPGresult; field_name:Pchar):longint;cdecl;
(* Const before type ignored *)
function PQftable(res:PPGresult; field_num:longint):Oid;cdecl;
(* Const before type ignored *)
function PQftablecol(res:PPGresult; field_num:longint):longint;cdecl;
(* Const before type ignored *)
function PQfformat(res:PPGresult; field_num:longint):longint;cdecl;
(* Const before type ignored *)
function PQftype(res:PPGresult; field_num:longint):Oid;cdecl;
(* Const before type ignored *)
function PQfsize(res:PPGresult; field_num:longint):longint;cdecl;
(* Const before type ignored *)
function PQfmod(res:PPGresult; field_num:longint):longint;cdecl;
function PQcmdStatus(res:PPGresult):Pchar;cdecl;
(* Const before type ignored *)
function PQoidStatus(res:PPGresult):Pchar;cdecl;
{ old and ugly  }
(* Const before type ignored *)
function PQoidValue(res:PPGresult):Oid;cdecl;
{ new and improved  }
function PQcmdTuples(res:PPGresult):Pchar;cdecl;
(* Const before type ignored *)
function PQgetvalue(res:PPGresult; tup_num:longint; field_num:longint):Pchar;cdecl;
(* Const before type ignored *)
function PQgetlength(res:PPGresult; tup_num:longint; field_num:longint):longint;cdecl;
(* Const before type ignored *)
function PQgetisnull(res:PPGresult; tup_num:longint; field_num:longint):longint;cdecl;
(* Const before type ignored *)
function PQnparams(res:PPGresult):longint;cdecl;
(* Const before type ignored *)
function PQparamtype(res:PPGresult; param_num:longint):Oid;cdecl;
{ Describe prepared statements and portals  }
(* Const before type ignored *)
function PQdescribePrepared(conn:PPGconn; stmt:Pchar):PPGresult;cdecl;
(* Const before type ignored *)
function PQdescribePortal(conn:PPGconn; portal:Pchar):PPGresult;cdecl;
(* Const before type ignored *)
function PQsendDescribePrepared(conn:PPGconn; stmt:Pchar):longint;cdecl;
(* Const before type ignored *)
function PQsendDescribePortal(conn:PPGconn; portal:Pchar):longint;cdecl;
{ Delete a PGresult  }
procedure PQclear(res:PPGresult);cdecl;
{ For freeing other alloc'd results, such as PGnotify structs  }
procedure PQfreemem(ptr:pointer);cdecl;
{ Exists for backward compatibility.  bjm 2003-03-24  }
{ was #define dname(params) para_def_expr }
{ argument types are unknown }
{ return type might be wrong }   
function PQfreeNotify(ptr : longint) : longint;

{ Error when no password was given.  }
{ Note: depending on this is deprecated; use PQconnectionNeedsPassword().  }
const
  PQnoPasswordSupplied = 'fe_sendauth: no password supplied\n';  
{ Create and manipulate PGresults  }

function PQmakeEmptyPGresult(conn:PPGconn; status:ExecStatusType):PPGresult;cdecl;
(* Const before type ignored *)
function PQcopyResult(src:PPGresult; flags:longint):PPGresult;cdecl;
function PQsetResultAttrs(res:PPGresult; numAttributes:longint; attDescs:PPGresAttDesc):longint;cdecl;
function PQresultAlloc(res:PPGresult; nBytes:size_t):pointer;cdecl;
function PQsetvalue(res:PPGresult; tup_num:longint; field_num:longint; value:Pchar; len:longint):longint;cdecl;
{ Quoting strings before inclusion in queries.  }
(* Const before type ignored *)
function PQescapeStringConn(conn:PPGconn; to:Pchar; from:Pchar; length:size_t; error:Plongint):size_t;cdecl;
(* Const before type ignored *)
function PQescapeByteaConn(conn:PPGconn; from:Pbyte; from_length:size_t; to_length:Psize_t):Pbyte;cdecl;
(* Const before type ignored *)
function PQunescapeBytea(strtext:Pbyte; retbuflen:Psize_t):Pbyte;cdecl;
{ These forms are deprecated!  }
(* Const before type ignored *)
function PQescapeString(to:Pchar; from:Pchar; length:size_t):size_t;cdecl;
(* Const before type ignored *)
function PQescapeBytea(from:Pbyte; from_length:size_t; to_length:Psize_t):Pbyte;cdecl;
{ === in fe-print.c ===  }
{ output stream  }
(* Const before type ignored *)
(* Const before type ignored *)
procedure PQprint(fout:PFILE; res:PPGresult; ps:PPQprintOpt);cdecl;
{ option structure  }
{
 * really old printing routines
  }
(* Const before type ignored *)
{ where to send the output  }
{ pad the fields with spaces  }
(* Const before type ignored *)
{ field separator  }
{ display headers?  }
procedure PQdisplayTuples(res:PPGresult; fp:PFILE; fillAlign:longint; fieldSep:Pchar; printHeader:longint; 
            quiet:longint);cdecl;
(* Const before type ignored *)
{ output stream  }
{ print attribute names  }
{ delimiter bars  }
procedure PQprintTuples(res:PPGresult; fout:PFILE; printAttName:longint; terseOutput:longint; width:longint);cdecl;
{ width of column, if 0, use variable width  }
{ === in fe-lobj.c ===  }
{ Large-object access routines  }
function lo_open(conn:PPGconn; lobjId:Oid; mode:longint):longint;cdecl;
function lo_close(conn:PPGconn; fd:longint):longint;cdecl;
function lo_read(conn:PPGconn; fd:longint; buf:Pchar; len:size_t):longint;cdecl;
(* Const before type ignored *)
function lo_write(conn:PPGconn; fd:longint; buf:Pchar; len:size_t):longint;cdecl;
function lo_lseek(conn:PPGconn; fd:longint; offset:longint; whence:longint):longint;cdecl;
function lo_creat(conn:PPGconn; mode:longint):Oid;cdecl;
function lo_create(conn:PPGconn; lobjId:Oid):Oid;cdecl;
function lo_tell(conn:PPGconn; fd:longint):longint;cdecl;
function lo_truncate(conn:PPGconn; fd:longint; len:size_t):longint;cdecl;
function lo_unlink(conn:PPGconn; lobjId:Oid):longint;cdecl;
(* Const before type ignored *)
function lo_import(conn:PPGconn; filename:Pchar):Oid;cdecl;
(* Const before type ignored *)
function lo_import_with_oid(conn:PPGconn; filename:Pchar; lobjId:Oid):Oid;cdecl;
(* Const before type ignored *)
function lo_export(conn:PPGconn; lobjId:Oid; filename:Pchar):longint;cdecl;
{ === in fe-misc.c ===  }
{ Determine length of multibyte encoded char at *s  }
(* Const before type ignored *)
function PQmblen(s:Pchar; encoding:longint):longint;cdecl;
{ Determine display length of multibyte encoded char at *s  }
(* Const before type ignored *)
function PQdsplen(s:Pchar; encoding:longint):longint;cdecl;
{ Get encoding id from environment variable PGCLIENTENCODING  }
function PQenv2encoding:longint;cdecl;
{ === in fe-auth.c ===  }
(* Const before type ignored *)
(* Const before type ignored *)
function PQencryptPassword(passwd:Pchar; user:Pchar):Pchar;cdecl;
{ === in encnames.c ===  }
(* Const before type ignored *)
function pg_char_to_encoding(name:Pchar):longint;cdecl;
(* Const before type ignored *)
function pg_encoding_to_char(encoding:longint):Pchar;cdecl;
function pg_valid_server_encoding_id(encoding:longint):longint;cdecl;
{ C++ end of extern C conditionnal removed }
{$endif}
{ LIBPQ_FE_H  }

implementation

{ was #define dname(params) para_def_expr }
{ argument types are unknown }
{ return type might be wrong }   
function PQsetdb(M_PGHOST,M_PGPORT,M_PGOPT,M_PGTTY,M_DBNAME : longint) : longint;
begin
  PQsetdb:=PQsetdbLogin(M_PGHOST,M_PGPORT,M_PGOPT,M_PGTTY,M_DBNAME,NULL,NULL);
end;

{ was #define dname(params) para_def_expr }
{ argument types are unknown }
{ return type might be wrong }   
function PQfreeNotify(ptr : longint) : longint;
begin
  PQfreeNotify:=PQfreemem(ptr);
end;


end.
