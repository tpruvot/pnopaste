# Copyright (c) 2011 Tanguy.Pruvot (gmail)
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

# This file was generated from the 'diff.xml' file of the syntax highlight
# engine of the kate text editor (http://www.kate-editor.org

#kate xml version 1.02
#kate version 2.4
#generated: Sun Mar 11 12:02:04 2012, localtime

package Syntax::Highlight::Engine::Kate::Dmesg;

use vars qw($VERSION);
$VERSION = '0.7';

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
      'DateTime prefix' => 'Normal',
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
   $self->deliminators('\\s|:|\\[|\\]');
   $self->basecontext('Normal');
   $self->keywordscase(0);
   $self->initialize;
   bless ($self, $class);
   return $self;
}

sub language {
   return 'Dmesg';
}

sub parseVerbose {
   return 0;
};

sub parseInfo {
   return 0;
};

sub parseWarning {
   return 0;
};

sub parseError {
   return 0;
};

sub parseDebug {
   return 0;
};


sub parseDateTime {
   my ($self, $text) = @_;
   #
   if ($self->testRegExpr($text, '(\\[\\d+\\.\\d+\\])', 0, 0, 0, undef, 0, '#stay', undef)) {
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
   #if ($self->testRegExpr($text, '(\\-\\-\\-)', 0, 0, 0, 0, 0, 'StartStop', 'Start and Stop')) {
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

   # attribute => 'Debug line'
   # column => undef
   # context => 'Debug'
   # if ($self->testStringDetect($text, '<7>', 0, 0, 0, undef, 0, 'Debug', 'Debug line')) {
   if ($self->testRegExpr($text, '<[789]>', 0, 0, 0, 0, 0, 'Debug', 'Debug line')) {
      return 1
   }
   if ($self->testStringDetect($text, '<6>', 0, 0, 0, undef, 0, 'Debug', 'Verbose line')) {
      return 1
   }
   if ($self->testStringDetect($text, '<5>', 0, 0, 0, undef, 0, 'Debug', 'Info line')) {
      return 1
   }
   if ($self->testStringDetect($text, '<4>', 0, 0, 0, undef, 0, 'Warning', 'Warning line')) {
      return 1
   }
   if ($self->testStringDetect($text, '<3>', 0, 0, 0, undef, 0, 'Error', 'Error line')) {
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
   #if ($self->testRegExpr($text, '\\d*\\.?\\d*e?\\d+', 0, 0, 0, undef, 0, '#stay', 'Number')) {
   #   return 1
   #}
   if ($self->testRegExpr($text, '0x[\\dabcdefABCDEF]+', 0, 0, 0, undef, 0, '#stay', 'Number')) {
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

Syntax::Highlight::Engine::Kate::Dmesg - a Plugin for dmesg -r highlighting (colored)

=head1 SYNOPSIS

 require Syntax::Highlight::Engine::Kate::Dmesg;
 my $sh = new Syntax::Highlight::Engine::Kate::Dmesg([
 ]);

=head1 DESCRIPTION

Syntax::Highlight::Engine::Kate::Dmesg is a plugin module that provides syntax highlighting
to the Syntax::Haghlight::Engine::Kate highlighting engine.

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

