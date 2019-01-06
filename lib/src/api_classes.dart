/// All classes exported over the RPC protocol.
library services.api_classes;

import 'package:rpc/rpc.dart';

/// The response from the `/version` service call.
class VersionResponse {
  @ApiProperty(description: 'The Dart SDK version that DartServices is compatible with. '
          'This will be a semver string.')
  final String sdkVersion;

  @ApiProperty(
      description:
          'The full Dart SDK version that DartServices is compatible with.')
  final String sdkVersionFull;

  VersionResponse({this.sdkVersion, this.sdkVersionFull});
}

/// Represents a reformatting of the code.
class FormatResponse {
  @ApiProperty(description: 'The formatted source code.')
  final String newString;

  @ApiProperty(description: 'The (optional) new offset of the cursor; can be `null`.')
  final int offset;

  FormatResponse(this.newString, [this.offset = 0]);
}
