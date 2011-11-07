# Copyright (c) 2011 Tanguy.Pruvot (gmail)
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

# This file was generated from the 'diff.xml' file of the syntax highlight
# engine of the kate text editor (http://www.kate-editor.org

#kate xml version 1.02
#kate version 2.4
#generated: Sun Nov  6 22:02:04 2011, localtime

package Syntax::Highlight::Engine::Kate::Logcat;

use vars qw($VERSION);
$VERSION = '0.03';

use strict;
use warnings;
use base('Syntax::Highlight::Engine::Kate::Template');

sub new {
   my $proto = shift;
   my $class = ref($proto) || $proto;
   my $self = $class->SUPER::new(@_);
   $self->attributes({
      'Comment' => 'Comment',
      'Data Type' => 'DataType',
      'Start and Stop' => 'Keyword',
      'Debug line' => 'DecVal',
      'Verbose line' => 'Normal',
      'Info line' => 'String',
      'Warning line' => 'Warning',
      'Error line' => 'Error',
      'Keyword' => 'Keyword',
      'DateTime prefix' => 'Keyword',
   });

   $self->listAdd('keywords',
#      'SystemServer',
#      'ActivityManager',
#      'Installer',
#      'PackageManager',
#      'Vold',
#      'InputManager',
#      'NetworkManagmentService',
#      'WifiService',
#      'ConnectivityService',
#      'TelephonyRegistry',
#      'UsbService',
   );

   $self->contextdata({
      'Verbose' => {
         callback => \&parseVerbose,
         attribute => 'Verbose line',
         fallthrough => '#pop',
         lineending => '#pop',
      },
      'Debug' => {
         callback => \&parseDebug,
         attribute => 'Debug line',
         fallthrough => '#pop',
         lineending => '#pop',
      },
      'Info' => {
         callback => \&parseInfo,
         attribute => 'Info line',
         fallthrough => '#pop',
         lineending => '#pop',
      },
      'Warning' => {
         callback => \&parseWarning,
         attribute => 'Warning line',
         fallthrough => '#pop',
         lineending => '#pop',
      },
      'Error' => {
         callback => \&parseError,
         attribute => 'Error line',
         fallthrough => '#pop',
         lineending => '#pop',
      },
      'DateTime' => {
         callback => \&parseDateTime,
         attribute => 'Normal Text',
         fallthrough => '#pop',
      },
      'StartStop' => {
         callback => \&parseStartStop,
         attribute => 'Start and Stop',
         fallthrough => '#pop',
      },
      'Keywords' => {
         callback => \&parseKeywords,
         attribute => 'Keywords',
         lineending => '#pop',
      },
      'Normal' => {
         callback => \&parseNormal,
         attribute => 'Normal Text',
      },
   });
   $self->deliminators('\\s|\\(|\\)|:|\\/|\\[|\\]|\\{|\\||\\}');
   $self->basecontext('Normal');
   $self->keywordscase(0);
   $self->initialize;
   bless ($self, $class);
   return $self;
}

sub language {
   return 'Android Logcat';
}

sub parseVerbose {
   my ($self, $text) = @_;
   return 0;
};

sub parseInfo {
   my ($self, $text) = @_;
   return 0;
};

sub parseWarning {
   my ($self, $text) = @_;
   return 0;
};

sub parseError {
   my ($self, $text) = @_;
   return 0;
};

sub parseDebug {
   my ($self, $text) = @_;
   return 0;
};


sub parseDateTime {
   my ($self, $text) = @_;
   #
   if ($self->testRegExpr($text, '([DVIWE]\\/)', 0, 0, 0, undef, 0, '#stay', undef)) {
      $self->highlightText($text);
      return 1
   }
   if ($self->testDetectSpaces($text, 0, undef, 0, '#stay', undef)) {
      return 1
   }
   return 0;
};

sub parseStartStop {
   my ($self, $text) = @_;
   return 0;
};

sub parseNormal {
   my ($self, $text) = @_;

   # String => '(\+\+\+|\-\-\-|\*\*\*)'
   # attribute => 'Start and Stop'
   # column => '0'
   # firstNonSpace => 'true'
   # context => 'StartStop'
   # type => 'RegExpr'
   #if ($self->testRegExpr($text, '(\\-\\-\\-)', 0, 0, 0, 0, 1, 'StartStop', 'Start and Stop')) {
   #   return 1
   #}

   # String => '\d+'
   # attribute => 'Date Time'
   # column => '0'
   # context => 'DateTime'
   # type => 'RegExpr'
   if ($self->testAnyChar($text, '0123456789-.:', 0, 0, 0, 0, 'DateTime', 'DateTime prefix')) {
      return 1
   }

   # String => 'keywords'
   # attribute => 'Keyword'
   # context => '#stay'
   # type => 'keyword'
   if ($self->testKeyword($text, 'keywords', 0, undef, 0, '#stay', 'Keyword')) {
      return 1
   }

   #testDetect2Chars(\$text, $char1, $char2, $insensitive, $dynamic,
   #                  $lookahead, $column, $firstnonspace, $context, $attribute);

   # String => 'D/'
   # attribute => 'Debug line'
   # column => undef
   # context => 'Debug'
   # type => 'Detect2Chars'
   if ($self->testStringDetect($text, 'D/', 0, 0, 0, undef, 0, 'Debug', 'Debug line')) {
      return 1
   }
   # String => 'V/'
   # attribute => 'Verbose line'
   # column => undef
   # context => 'Verbose'
   # type => 'RegExpr'
   if ($self->testDetect2Chars($text, 'V','/', 0, 0, 0, undef, 0, 'Verbose', 'Verbose line')) {
      return 1
   }
   # String => 'I/'
   # attribute => 'Info line'
   # column => undef
   # context => 'Info'
   # type => 'RegExpr'
   if ($self->testDetect2Chars($text, 'I','/', 0, 0, 0, undef, 0, 'Info', 'Info line')) {
      return 1
   }
   # String => 'W/'
   # attribute => 'Warning line'
   # column => undef
   # context => 'Warning'
   # type => 'RegExpr'
   if ($self->testDetect2Chars($text, 'W','/', 0, 0, 0, undef, 0, 'Warning', 'Warning line')) {
      return 1
   }
   # String => 'E/'
   # attribute => 'Error line'
   # column => undef
   # context => 'Error'
   # type => 'RegExpr'
   if ($self->testDetect2Chars($text, 'E','/', 0, 0, 0, undef, 0, 'Error', 'Error line')) {
      return 1
   }

   # String => '-<'
   # attribute => 'Removed line'
   # column => '0'
   # context => 'Removed'
   # type => 'AnyChar'
   #if ($self->testAnyChar($text, '-<', 0, 0, 0, 0, 'Removed', 'Removed line')) {
   #   return 1
   #}

   # String => '!%&()+,-<=>?[]^{|}~'
   # attribute => 'Symbol'
   # context => '#stay'
   # type => 'AnyChar'
   if ($self->testAnyChar($text, '!%&()+,-<=>?[]^{|}~', 0, 0, undef, 0, '#stay', 'Symbol')) {
      return 1
   }
   # String => '\d*\.?\d*e?\d+'
   # attribute => 'Number'
   # context => '#stay'
   # type => 'RegExpr'
   if ($self->testRegExpr($text, '\\d*\\.?\\d*e?\\d+', 0, 0, 0, undef, 0, '#stay', 'Number')) {
      return 1
   }
   return 0;
};

sub parseFindValues {
   my ($self, $text) = @_;

   return 0;
};


1;

__END__

=head1 NAME

Syntax::Highlight::Engine::Kate::Logcat - a Plugin for Android Logcat syntax highlighting

=head1 SYNOPSIS

 require Syntax::Highlight::Engine::Kate::Logcat;
 my $sh = new Syntax::Highlight::Engine::Kate::Logcat([
 ]);

=head1 DESCRIPTION

Syntax::Highlight::Engine::Kate::Logcat is a plugin module that provides syntax highlighting
for Diff to the Syntax::Haghlight::Engine::Logcat highlighting engine.

This code is generated from the syntax definition files used
by the Kate project.
It works quite fine, but can use refinement and optimization.

It inherits Syntax::Higlight::Engine::Kate::Template. See also there.

=cut

=head1 AUTHOR

Tanguy Pruvot (tanguy <dot> pruvot <at> gmail)

=cut

=head1 BUGS

Unknown. If you find any, please contact the author

=cut

