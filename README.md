# gRPC Binary for UE5

gRPC libraries for Unreal Engine 5.5 (Windows x64, /MD runtime)

grpcのビルドスクリプトとビルド済みバイナリ。`ThirdParty/`にビルド済みのライブラリとヘッダーがあるので、UE5プラグイン作成時にリンクとインクルードパスを設定すれば使えます。

## Build

```powershell
.\build_for_ue5.ps1
```

ビルド成果物は`.build_ue5/Release/`に出力されます。手動で`ThirdParty/`にコピー済み。
`ThirdParty/Includes`に入ってるのはごちゃごちゃやって必要そうだったやつを適当にこぴってきました。

## Protoの生成

```cmd
generate_proto.cmd [PROTO_DIR] [OUTPUT_DIR]
```

Example:
```cmd
generate_proto.cmd "C:\MyProtos" "C:\MyProject\Source\Generated"
```

## License

Apache License 2.0 (gRPCのライブラリのLICENSEを確認してください。)
