defmodule Gazettex.Protocol.Status do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:OK, 0)
  field(:JOURNAL_NOT_FOUND, 1)
  field(:NO_JOURNAL_PRIMARY_BROKER, 2)
  field(:NOT_JOURNAL_PRIMARY_BROKER, 3)
  field(:NOT_JOURNAL_BROKER, 5)
  field(:INSUFFICIENT_JOURNAL_BROKERS, 4)
  field(:OFFSET_NOT_YET_AVAILABLE, 6)
  field(:WRONG_ROUTE, 7)
  field(:PROPOSAL_MISMATCH, 8)
  field(:ETCD_TRANSACTION_FAILED, 9)
  field(:NOT_ALLOWED, 10)
  field(:WRONG_APPEND_OFFSET, 11)
  field(:INDEX_HAS_GREATER_OFFSET, 12)
  field(:REGISTER_MISMATCH, 13)
end

defmodule Gazettex.Protocol.CompressionCodec do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:INVALID, 0)
  field(:NONE, 1)
  field(:GZIP, 2)
  field(:ZSTANDARD, 3)
  field(:SNAPPY, 4)
  field(:GZIP_OFFLOAD_DECOMPRESSION, 5)
end

defmodule Gazettex.Protocol.JournalSpec.Flag do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:NOT_SPECIFIED, 0)
  field(:O_RDONLY, 1)
  field(:O_WRONLY, 2)
  field(:O_RDWR, 4)
end

defmodule Gazettex.Protocol.Label do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:name, 1, type: :string)
  field(:value, 2, type: :string)
end

defmodule Gazettex.Protocol.LabelSet do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:labels, 1, repeated: true, type: Gazettex.Protocol.Label, deprecated: false)
end

defmodule Gazettex.Protocol.LabelSelector do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:include, 1, type: Gazettex.Protocol.LabelSet, deprecated: false)
  field(:exclude, 2, type: Gazettex.Protocol.LabelSet, deprecated: false)
end

defmodule Gazettex.Protocol.JournalSpec.Fragment do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:length, 1, type: :int64, deprecated: false)

  field(:compression_codec, 2,
    type: Gazettex.Protocol.CompressionCodec,
    json_name: "compressionCodec",
    enum: true,
    deprecated: false
  )

  field(:stores, 3, repeated: true, type: :string, deprecated: false)

  field(:refresh_interval, 4,
    type: Google.Protobuf.Duration,
    json_name: "refreshInterval",
    deprecated: false
  )

  field(:retention, 5, type: Google.Protobuf.Duration, deprecated: false)

  field(:flush_interval, 6,
    type: Google.Protobuf.Duration,
    json_name: "flushInterval",
    deprecated: false
  )

  field(:path_postfix_template, 7,
    type: :string,
    json_name: "pathPostfixTemplate",
    deprecated: false
  )
end

defmodule Gazettex.Protocol.JournalSpec do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:name, 1, type: :string, deprecated: false)
  field(:replication, 2, type: :int32, deprecated: false)
  field(:labels, 3, type: Gazettex.Protocol.LabelSet, deprecated: false)
  field(:fragment, 4, type: Gazettex.Protocol.JournalSpec.Fragment, deprecated: false)
  field(:flags, 6, type: :uint32, deprecated: false)
  field(:max_append_rate, 7, type: :int64, json_name: "maxAppendRate", deprecated: false)
end

defmodule Gazettex.Protocol.ProcessSpec.ID do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:zone, 1, type: :string)
  field(:suffix, 2, type: :string)
end

defmodule Gazettex.Protocol.ProcessSpec do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:id, 1, type: Gazettex.Protocol.ProcessSpec.ID, deprecated: false)
  field(:endpoint, 2, type: :string, deprecated: false)
end

defmodule Gazettex.Protocol.BrokerSpec do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:process_spec, 1,
    type: Gazettex.Protocol.ProcessSpec,
    json_name: "processSpec",
    deprecated: false
  )

  field(:journal_limit, 2, type: :uint32, json_name: "journalLimit")
end

defmodule Gazettex.Protocol.Fragment do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:journal, 1, type: :string, deprecated: false)
  field(:begin, 2, type: :int64, deprecated: false)
  field(:end, 3, type: :int64, deprecated: false)
  field(:sum, 4, type: Gazettex.Protocol.SHA1Sum, deprecated: false)

  field(:compression_codec, 5,
    type: Gazettex.Protocol.CompressionCodec,
    json_name: "compressionCodec",
    enum: true
  )

  field(:backing_store, 6, type: :string, json_name: "backingStore", deprecated: false)
  field(:mod_time, 7, type: :int64, json_name: "modTime")
  field(:path_postfix, 8, type: :string, json_name: "pathPostfix")
end

defmodule Gazettex.Protocol.SHA1Sum do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:part1, 1, type: :fixed64)
  field(:part2, 2, type: :fixed64)
  field(:part3, 3, type: :fixed32)
end

defmodule Gazettex.Protocol.ReadRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:header, 1, type: Gazettex.Protocol.Header)
  field(:journal, 2, type: :string, deprecated: false)
  field(:offset, 3, type: :int64, deprecated: false)
  field(:block, 4, type: :bool)
  field(:do_not_proxy, 5, type: :bool, json_name: "doNotProxy")
  field(:metadata_only, 6, type: :bool, json_name: "metadataOnly")
  field(:end_offset, 7, type: :int64, json_name: "endOffset", deprecated: false)
  field(:begin_mod_time, 8, type: :int64, json_name: "beginModTime")
end

defmodule Gazettex.Protocol.ReadResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: Gazettex.Protocol.Status, enum: true)
  field(:header, 2, type: Gazettex.Protocol.Header)
  field(:offset, 3, type: :int64, deprecated: false)
  field(:write_head, 4, type: :int64, json_name: "writeHead", deprecated: false)
  field(:fragment, 5, type: Gazettex.Protocol.Fragment)
  field(:fragment_url, 6, type: :string, json_name: "fragmentUrl")
  field(:content, 7, type: :bytes)
end

defmodule Gazettex.Protocol.AppendRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:header, 1, type: Gazettex.Protocol.Header)
  field(:journal, 2, type: :string, deprecated: false)
  field(:do_not_proxy, 3, type: :bool, json_name: "doNotProxy")
  field(:offset, 5, type: :int64, deprecated: false)
  field(:check_registers, 6, type: Gazettex.Protocol.LabelSelector, json_name: "checkRegisters")
  field(:union_registers, 7, type: Gazettex.Protocol.LabelSet, json_name: "unionRegisters")
  field(:subtract_registers, 8, type: Gazettex.Protocol.LabelSet, json_name: "subtractRegisters")
  field(:content, 4, type: :bytes)
end

defmodule Gazettex.Protocol.AppendResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: Gazettex.Protocol.Status, enum: true)
  field(:header, 2, type: Gazettex.Protocol.Header, deprecated: false)
  field(:commit, 3, type: Gazettex.Protocol.Fragment)
  field(:registers, 4, type: Gazettex.Protocol.LabelSet)
  field(:total_chunks, 5, type: :int64, json_name: "totalChunks")
  field(:delayed_chunks, 6, type: :int64, json_name: "delayedChunks")
end

defmodule Gazettex.Protocol.ReplicateRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:header, 1, type: Gazettex.Protocol.Header)
  field(:proposal, 3, type: Gazettex.Protocol.Fragment)
  field(:registers, 7, type: Gazettex.Protocol.LabelSet)
  field(:acknowledge, 6, type: :bool)
  field(:deprecated_journal, 2, type: :string, json_name: "deprecatedJournal", deprecated: false)
  field(:content, 4, type: :bytes)
  field(:content_delta, 5, type: :int64, json_name: "contentDelta")
end

defmodule Gazettex.Protocol.ReplicateResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: Gazettex.Protocol.Status, enum: true)
  field(:header, 2, type: Gazettex.Protocol.Header)
  field(:fragment, 3, type: Gazettex.Protocol.Fragment)
  field(:registers, 4, type: Gazettex.Protocol.LabelSet)
end

defmodule Gazettex.Protocol.ListRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:selector, 1, type: Gazettex.Protocol.LabelSelector, deprecated: false)
end

defmodule Gazettex.Protocol.ListResponse.Journal do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:spec, 1, type: Gazettex.Protocol.JournalSpec, deprecated: false)
  field(:mod_revision, 2, type: :int64, json_name: "modRevision")
  field(:route, 3, type: Gazettex.Protocol.Route, deprecated: false)
end

defmodule Gazettex.Protocol.ListResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: Gazettex.Protocol.Status, enum: true)
  field(:header, 2, type: Gazettex.Protocol.Header, deprecated: false)

  field(:journals, 3,
    repeated: true,
    type: Gazettex.Protocol.ListResponse.Journal,
    deprecated: false
  )
end

defmodule Gazettex.Protocol.ApplyRequest.Change do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:expect_mod_revision, 1, type: :int64, json_name: "expectModRevision")
  field(:upsert, 2, type: Gazettex.Protocol.JournalSpec)
  field(:delete, 3, type: :string, deprecated: false)
end

defmodule Gazettex.Protocol.ApplyRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:changes, 1,
    repeated: true,
    type: Gazettex.Protocol.ApplyRequest.Change,
    deprecated: false
  )
end

defmodule Gazettex.Protocol.ApplyResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: Gazettex.Protocol.Status, enum: true)
  field(:header, 2, type: Gazettex.Protocol.Header, deprecated: false)
end

defmodule Gazettex.Protocol.FragmentsRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:header, 1, type: Gazettex.Protocol.Header)
  field(:journal, 2, type: :string, deprecated: false)
  field(:begin_mod_time, 3, type: :int64, json_name: "beginModTime")
  field(:end_mod_time, 4, type: :int64, json_name: "endModTime")
  field(:next_page_token, 5, type: :int64, json_name: "nextPageToken")
  field(:page_limit, 6, type: :int32, json_name: "pageLimit")
  field(:signatureTTL, 7, type: Google.Protobuf.Duration, deprecated: false)
  field(:do_not_proxy, 8, type: :bool, json_name: "doNotProxy")
end

defmodule Gazettex.Protocol.FragmentsResponse.Fragment do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:spec, 1, type: Gazettex.Protocol.Fragment, deprecated: false)
  field(:signed_url, 2, type: :string, json_name: "signedUrl")
end

defmodule Gazettex.Protocol.FragmentsResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:status, 1, type: Gazettex.Protocol.Status, enum: true)
  field(:header, 2, type: Gazettex.Protocol.Header, deprecated: false)

  field(:fragments, 3,
    repeated: true,
    type: Gazettex.Protocol.FragmentsResponse.Fragment,
    deprecated: false
  )

  field(:next_page_token, 4, type: :int64, json_name: "nextPageToken")
end

defmodule Gazettex.Protocol.Route do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:members, 1, repeated: true, type: Gazettex.Protocol.ProcessSpec.ID, deprecated: false)
  field(:primary, 2, type: :int32)
  field(:endpoints, 3, repeated: true, type: :string, deprecated: false)
end

defmodule Gazettex.Protocol.Header.Etcd do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:cluster_id, 1, type: :uint64, json_name: "clusterId")
  field(:member_id, 2, type: :uint64, json_name: "memberId")
  field(:revision, 3, type: :int64)
  field(:raft_term, 4, type: :uint64, json_name: "raftTerm")
end

defmodule Gazettex.Protocol.Header do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:process_id, 1,
    type: Gazettex.Protocol.ProcessSpec.ID,
    json_name: "processId",
    deprecated: false
  )

  field(:route, 2, type: Gazettex.Protocol.Route, deprecated: false)
  field(:etcd, 3, type: Gazettex.Protocol.Header.Etcd, deprecated: false)
end

defmodule Gazettex.Protocol.Journal.Service do
  @moduledoc false

  use GRPC.Service, name: "protocol.Journal", protoc_gen_elixir_version: "0.12.0"

  rpc(:List, Gazettex.Protocol.ListRequest, Gazettex.Protocol.ListResponse)

  rpc(:Apply, Gazettex.Protocol.ApplyRequest, Gazettex.Protocol.ApplyResponse)

  rpc(:Read, Gazettex.Protocol.ReadRequest, stream(Gazettex.Protocol.ReadResponse))

  rpc(:Append, stream(Gazettex.Protocol.AppendRequest), Gazettex.Protocol.AppendResponse)

  rpc(
    :Replicate,
    stream(Gazettex.Protocol.ReplicateRequest),
    stream(Gazettex.Protocol.ReplicateResponse)
  )

  rpc(:ListFragments, Gazettex.Protocol.FragmentsRequest, Gazettex.Protocol.FragmentsResponse)
end

defmodule Gazettex.Protocol.Journal.Stub do
  @moduledoc false

  use GRPC.Stub, service: Gazettex.Protocol.Journal.Service
end
